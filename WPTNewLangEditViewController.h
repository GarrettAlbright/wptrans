//
//  WPTNewLangEditViewController.h
//  WPTrans
//
//  Created by Garrett Albright on 2/17/14.
//  Copyright (c) 2014 Garrett Albright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPTNewLangEditViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
    UITableView *langTable;
}

- (void)closeSelf;

@end
