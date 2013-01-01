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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nilOut) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

-(void)nilOut {
    langs = nil;
    filteredLangs = nil;
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
    for (WPTLang *lang in [self allLangs]) {
        if ([[lang langcode] isEqual:langcode]) {
            return lang;
        }
    }
    return nil;
}

-(NSArray *)allLangs {
    if (!langs) {
        NSBundle *appBundle = [NSBundle mainBundle];
        NSString *fname = [appBundle pathForResource:@"wikipedias" ofType:@"plist"];
        NSArray *langsFromPlist = [[NSArray alloc] initWithContentsOfFile:fname];
        NSArray *enabledLangs = [[NSUserDefaults standardUserDefaults] arrayForKey:@"enabledLanguages"];
        NSMutableArray *filteredArray = [[NSMutableArray alloc] initWithCapacity:[langsFromPlist count]];
        for (NSDictionary *lang in langsFromPlist) {
            NSString *langcode = [lang objectForKey:@"prefix"];
            BOOL inDefault = [enabledLangs containsObject:langcode];
            WPTLang *langObj = [[WPTLang alloc] initWithLanguage:[lang objectForKey:@"loclang"] langcode:langcode isEnabled:inDefault];
            [filteredArray addObject:langObj];
        }
        // Sort the languages in "alphabetical" order
        NSSortDescriptor *byLang = [NSSortDescriptor sortDescriptorWithKey:@"language" ascending:YES];
        langs = [filteredArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:byLang]];
    }
    return langs;
}

-(NSArray *)enabledLangs {
    if (!filteredLangs) {
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"isEnabled == YES"];
        filteredLangs = [[self allLangs] filteredArrayUsingPredicate:filter];
    }
    return filteredLangs;
}

-(NSArray *)enabledLangcodes {
    NSArray *enabledLangs = [self enabledLangs];
    NSMutableArray *enabledLangcodes = [[NSMutableArray alloc] initWithCapacity:[enabledLangs count]];
    for (WPTLang *lang in enabledLangs) {
        [enabledLangcodes addObject:[lang langcode]];
    }
    return (NSArray *)enabledLangcodes;
}

-(void)enabledLangsWasUpdated {
    // Nil out filteredLangsAlphaOrder so that the next call to enabledLangs
    // will rebuild the list.
    filteredLangs = nil;
    [[NSUserDefaults standardUserDefaults] setObject:[self enabledLangcodes] forKey:@"enabledLanguages"];
}

@end
