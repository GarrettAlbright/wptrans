//
//  WPTLangEditViewController.h
//  WPTrans
//
//  Created by Garrett Albright on 12/30/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPTLangEditViewController : UIViewController <UITableViewDelegate, UIActionSheetDelegate> {
    
    __weak IBOutlet UIBarButtonItem *doneButton;
    __weak IBOutlet UITableView *langTable;
    __weak IBOutlet UINavigationItem *navBar;
}

@end
