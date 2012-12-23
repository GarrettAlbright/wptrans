//
//  WPTLanguageBase.h
//  WPTrans
//
//  Created by Garrett Albright on 12/23/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPTLangBase : NSObject
{
    NSArray *langsAlphaOrder;
}

+ (WPTLangBase *)sharedBase;
- (NSString *)languageForCode: (NSString *)langCode;
- (NSArray *)allLangs;

@end
