//
//  WPTLicenseViewController.h
//  WPTrans
//
//  Created by Garrett Albright on 2/13/14.
//  Copyright (c) 2014 Garrett Albright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPTLicenseViewController : UIViewController

- (WPTLicenseViewController *)initWithLicenseInfo: (NSDictionary *)licenseInfo;
- (void) closeSelf;

@end
