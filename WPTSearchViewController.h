//
//  WPTSearchViewController.h
//  WPTrans
//
//  Created by Garrett Albright on 2/15/14.
//  Copyright (c) 2014 Garrett Albright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPTLang.h"
#import "WPTWPRequestDelegate.h"

@interface WPTSearchViewController : UITableViewController <UISearchBarDelegate, WPTWPRequestDelegate, UIActionSheetDelegate> {
    UISearchBar *searchTermBar;

    NSString *searchTerm;
    NSString *langcode;
    NSArray *results;
}

- (id)initWithLang:(WPTLang *)lang searchTerm:(NSString *)initSearchTerm;
- (void)startSearch;

@end
