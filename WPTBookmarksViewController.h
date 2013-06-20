//
//  WPTBookmarksViewController.h
//  WPTrans
//
//  Created by Garrett Albright on 6/16/13.
//  Copyright (c) 2013 Garrett Albright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPTBookmarksViewController : UITableViewController {
    NSDictionary *theBookmarks;
}

- (void)startEdit;
- (void)stopEdit;

@end
