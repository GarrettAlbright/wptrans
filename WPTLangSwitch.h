//
//  WPTLangSwitch.h
//  WPTrans
//
//  Created by Garrett Albright on 12/30/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPTLangSwitch : UISwitch {
    NSString *langcode;
}

- (WPTLangSwitch *)initWithLangcode: (NSString *)initLangcode;
- (void)toggled;

@end
