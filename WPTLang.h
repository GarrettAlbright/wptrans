//
//  WPTLang.h
//  WPTrans
//
//  Created by Garrett Albright on 12/27/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPTLang : NSObject

@property (nonatomic) BOOL isEnabled;
@property (nonatomic, readonly) NSString *language;
@property (nonatomic, readonly) NSString *langcode;

- (WPTLang *)initWithLanguage: (NSString *)initLanguage langcode: (NSString *)initLangcode isEnabled: (BOOL)initEnabled;
- (void)toggleEnabled;

@end
