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
            // The default available languages. This list was constructed by
            // selecting the top twenty languages by speakers (note that's
            // *total* speakers, not *native* speakers) from the list at
            // http://www.ethnologue.org/ethno_docs/distribution.asp?by=size
            // which itself is a source on the Wikipedia article "List of
            // languages by total number of speakers." Each language was then
            // inexpertly matched up with the Wikipedia language code
            // equivalent. The list is flawed for our use case, since:
            // - "Speakers" is not necessarily equivalent to "readers"
            // - The actual usage data for those that use this app will probably
            //   differ (perhaps more people are using this app to look up words
            //   in Dutch or Swahili than Telugu and Tamil)
            // - Probably many other reasons I have yet to consider
            // …but for the lack of any other better lists at the moment, here
            // we go.
            NSArray *defaultLangs = [[NSArray alloc] initWithObjects:
                                     @"zh", // Chinese
                                     @"es", // Spanish
                                     @"en", // English
                                     @"ar", // Arabic
                                     @"hi", // Hindi
                                     @"bn", // Bengali
                                     @"pt", // Portuguese
                                     @"ru", // Russian
                                     @"ja", // Japanese
                                     @"de", // German
                                     @"jv", // Javanese
                                     @"pa", // Punjabi
                                     @"te", // Telugu
                                     @"vi", // Vietnamese
                                     @"mr", // Marathi
                                     @"fr", // French
                                     @"ko", // Korean
                                     @"ta", // Tamil
                                     @"it", // Italian
                                     @"ur", // Urdu
                                     nil];
            NSMutableArray *filteredArray = [[NSMutableArray alloc] initWithCapacity:[langsFromPlist count]];
            for (NSDictionary *lang in langsFromPlist) {
                NSString *langcode = [lang objectForKey:@"prefix"];
                BOOL inDefault = [defaultLangs containsObject:langcode];
                WPTLang *langObj = [[WPTLang alloc] initWithLanguage:[lang objectForKey:@"loclang"] langcode:langcode isEnabled:inDefault];
                [filteredArray addObject:langObj];
            }
            // Sort the languages in "alphabetical" order
            NSSortDescriptor *byLang = [NSSortDescriptor sortDescriptorWithKey:@"language" ascending:YES];
            langsAlphaOrder = [filteredArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:byLang]];
            
        }
    }
    return self;
}

-(NSString *)languageForCode:(NSString *)langcode
{
    WPTLang *lang = [self langObjectForCode:langcode];
    if (lang) {
        return [lang language];
    }
    return nil;
}

-(WPTLang *)langObjectForCode:(NSString *)langcode
{
    // @todo Use filteredArrayUsingPredicate? Store dictionary keyed by
    // langcode even though that increases memory? Or just live with this?
    for (WPTLang *lang in langsAlphaOrder) {
        if ([[lang langcode] isEqual:langcode]) {
            return lang;
        }
    }
    return nil;
}

-(NSArray *)allLangs {
    return langsAlphaOrder;
}

-(NSArray *)enabledLangs {
    if (!filteredLangsAlphaOrder) {
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"isEnabled == YES"];
        filteredLangsAlphaOrder = [langsAlphaOrder filteredArrayUsingPredicate:filter];
    }
    return filteredLangsAlphaOrder;
}

-(void)enabledLangsWasUpdated {
    // Nil out filteredLangsAlphaOrder so that the next call to enabledLangs
    // will rebuild the list.
    filteredLangsAlphaOrder = nil;
    // @todo Save user preference data here.
}

@end
