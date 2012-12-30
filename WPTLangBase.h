//
//  WPTLanguageBase.h
//  WPTrans
//
//  Created by Garrett Albright on 12/23/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPTLang.h"

@interface WPTLangBase : NSObject
{
    // @todo Should these be @syntehsized properties instead of these things?
    NSArray *langsAlphaOrder;
    NSArray *filteredLangsAlphaOrder;
}

+ (WPTLangBase *)sharedBase;
- (NSString *)languageForCode:(NSString *)langCode;
- (WPTLang *)langObjectForCode:(NSString *)langcode;
- (NSArray *)allLangs;
- (NSArray *)enabledLangs;
- (void)enabledLangsWasUpdated;

@end
