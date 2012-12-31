//
//  WPTNewSearchViewController.h
//  WPTrans
//
//  Created by Garrett Albright on 12/30/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPTLang.h"

@interface WPTNewSearchViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate> {
    NSString *langcode;
    NSArray *results;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITableView *resultsTable;
    IBOutlet UISearchBar *searchTermBar;
}

- (id)initWithLang:(WPTLang *)lang;

@end
