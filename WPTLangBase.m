//
//  WPTLanguageBase.m
//  WPTrans
//
//  Created by Garrett Albright on 12/23/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import "WPTLangBase.h"

@implementation WPTLangBase

+ (WPTLangBase *)sharedBase
{
    static WPTLangBase *langBase = nil;
    if (!langBase) {
        langBase = [[super allocWithZone:nil] init];
    }
    return langBase;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedBase];
}

- (id)init
{
    self = [super init];
    if (self) {
        if (!langsAlphaOrder) {
            NSBundle *appBundle = [NSBundle mainBundle];
            NSString *fname = [appBundle pathForResource:@"wikipedias" ofType:@"plist"];
            NSArray *langsFromPlist = [[NSArray alloc] initWithContentsOfFile:fname];
            NSMutableArray *filteredArray = [[NSMutableArray alloc] initWithCapacity:[langsFromPlist count]];
            for (NSDictionary *lang in langsFromPlist) {
                // @todo Is there a nicer way to only select wanted items from
                // one dictionary and create another dictionary with them?
                NSMutableDictionary *filteredLang = [[NSMutableDictionary alloc] initWithCapacity:2];
                [filteredLang setObject:[lang objectForKey:@"loclang"] forKey:@"loclang"];
                [filteredLang setObject:[lang objectForKey:@"prefix"] forKey:@"prefix"];
                [filteredArray addObject:filteredLang];
            }
            // Sort the languages in "alphabetical" order
            NSSortDescriptor *byLang = [NSSortDescriptor sortDescriptorWithKey:@"loclang" ascending:YES];
            langsAlphaOrder = [filteredArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:byLang]];
            
        }
    }
    return self;
}

-(NSString *)languageForCode:(NSString *)langCode
{
    // @todo Use filteredArrayUsingPredicate? Store dictionary keyed by
    // langcode even though that increases memory? Or just live with this?
    for (NSDictionary *langDict in langsAlphaOrder) {
        if (langCode == [langDict objectForKey:@"prefix"]) {
            return [langDict objectForKey:@"loclang"];
        }
    }
    return nil;
}

-(NSArray *)allLangs {
    return langsAlphaOrder;
}



@end
