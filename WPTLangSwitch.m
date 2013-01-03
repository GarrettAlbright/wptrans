//
//  WPTLangSwitch.m
//  WPTrans
//
//  Created by Garrett Albright on 12/30/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import "WPTLangSwitch.h"
#import "WPTLang.h"
#import "WPTLangBase.h"

@implementation WPTLangSwitch

- (WPTLangSwitch *)initWithLangcode: (NSString *)initLangcode {
    self = [super init];
    if (self) {
        langcode = initLangcode;
    }
    return self;
}

- (void)toggled {
    WPTLang *lang = [[WPTLangBase sharedBase] langObjectForCode:langcode];
    if (lang) {
        [lang toggleEnabled];
    }
}

@end
