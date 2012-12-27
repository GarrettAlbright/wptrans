//
//  WPTLanguageBase.m
//  WPTrans
//
//  Created by Garrett Albright on 12/23/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import "WPTLangBase.h"
#import "WPTLang.h"

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
                WPTLang *langObj = [[WPTLang alloc] initWithLanguage:[lang objectForKey:@"loclang"] langcode:[lang objectForKey:@"prefix"] isEnabled:YES];
                [filteredArray addObject:langObj];
            }
            // Sort the languages in "alphabetical" order
            NSSortDescriptor *byLang = [NSSortDescriptor sortDescriptorWithKey:@"language" ascending:YES];
            langsAlphaOrder = [filteredArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:byLang]];
            
        }
    }
    return self;
}

-(NSString *)languageForCode:(NSString *)langCode
{
    // @todo Use filteredArrayUsingPredicate? Store dictionary keyed by
    // langcode even though that increases memory? Or just live with this?
    for (WPTLang *lang in langsAlphaOrder) {
        if ([[lang langcode] isEqual:langCode]) {
            return [lang language];
        }
    }
    return nil;
}

-(NSArray *)allLangs {
    return langsAlphaOrder;
}



@end
