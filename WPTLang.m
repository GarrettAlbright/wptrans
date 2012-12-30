//
//  WPTLang.m
//  WPTrans
//
//  Created by Garrett Albright on 12/27/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import "WPTLang.h"

@implementation WPTLang

@synthesize language, langcode, isEnabled;

- (WPTLang *)initWithLanguage: (NSString *)initLanguage langcode: (NSString *)initLangcode isEnabled: (BOOL)initIsEnabled {
    self = [self init];
    if (self) {
        language = initLanguage;
        langcode = initLangcode;
        isEnabled = initIsEnabled;
    }
    return self;
}

- (void)toggleEnabled
{
    isEnabled = !isEnabled;
}

@end
