//
//  WPTBookmarksBase.m
//  WPTrans
//
//  Created by Garrett Albright on 6/18/13.
//  Copyright (c) 2013 Garrett Albright. All rights reserved.
//

#import "WPTBookmarksBase.h"

@implementation WPTBookmarksBase

+ (WPTBookmarksBase *)sharedBase
{
    static WPTBookmarksBase *bookmarksBase = nil;
    if (!bookmarksBase) {
        bookmarksBase = [[super allocWithZone:nil] init];
    }
    return bookmarksBase;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedBase];
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nilOut) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

-(void)nilOut
{
    theBookmarks = nil;
}

- (NSDictionary *)allBookmarks
{
    if (theBookmarks == nil) {
        NSDictionary *unsortedBookmarks = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookmarks"];
        NSMutableDictionary *sortedBookmarks = [[NSMutableDictionary alloc] initWithCapacity:[unsortedBookmarks count]];
        for (NSString *langcode in [[unsortedBookmarks allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
            NSArray *terms = [unsortedBookmarks objectForKey:langcode];
            if ([terms count]) {
                [sortedBookmarks setValue:[terms sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] forKey:langcode];
            }
        }
        theBookmarks = [sortedBookmarks mutableCopy];
    }
    return theBookmarks;
}

- (NSString *)langcodeForIndex:(NSUInteger)index
{
    return [[[self allBookmarks] allKeys] objectAtIndex:index];
}

- (NSString *)getTermForIndexPath:(NSIndexPath *)indexPath
{
    NSString *langcode = [self langcodeForIndex:[indexPath section]];
    return [[[self allBookmarks] objectForKey:langcode] objectAtIndex:[indexPath row]];
}

- (NSUInteger) numberOfTermsInLanguageAtIndex:(NSUInteger)index {
    return [[[self allBookmarks] objectForKey:[self langcodeForIndex:index]] count];
}

- (BOOL)addSearchTerm:(NSString *)term forLangcode:(NSString *)langcode
{
    NSMutableArray *terms = [[[self allBookmarks] objectForKey:langcode] mutableCopy];
    if (terms == nil) {
        [theBookmarks setObject:@[term] forKey:langcode];
    }
    else if ([terms containsObject:term]) {
        return NO;
    }
    else {
        [terms addObject:term];
        [theBookmarks setObject:terms forKey:langcode];
    }
    [self saveState];
    // Nil out the bookmarks because we want them to be rebuilt and resorted
    // on the next call to allBookmarks.
    [self nilOut];
    return YES;
}

- (BOOL)deleteSearchTerm:(NSString *)term forLangcode:(NSString *)langcode {
    NSMutableArray *terms = [[[self allBookmarks] objectForKey:langcode] mutableCopy];
    if (terms == nil) {
        return NO;
    }
    else {
        NSUInteger position = [terms indexOfObject:term];
        if (position == NSNotFound) {
            return NO;
        }
        else {
            if ([terms count] == 1) {
                // There's not going to be any terms left for this langcode, so
                // just remove it from the bookmarks completely.
                [theBookmarks removeObjectForKey:langcode];
            }
            else {
                [terms removeObjectAtIndex:position];
                [theBookmarks setObject:terms forKey:langcode];
            }
            [self saveState];
            return YES;
        }
    }
}

- (BOOL)deleteSearchTermAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *langcode = [self langcodeForIndex:[indexPath section]];
    if (langcode == nil) {
        return NO;
    }
    else {
        NSString *term = [self getTermForIndexPath:indexPath];
        if (term == nil) {
            return NO;
        }
        else {
            return [self deleteSearchTerm:term forLangcode:langcode];
        }
    }
}

- (void)saveState
{
    [[NSUserDefaults standardUserDefaults] setObject:theBookmarks forKey:@"bookmarks"];
}
@end
