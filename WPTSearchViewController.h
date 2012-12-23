//
//  WPTSearchViewController.h
//  WPTrans
//
//  Created by Garrett Albright on 12/20/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPTWPRequest.h"

@interface WPTSearchViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
{
    NSString *langPrefix;
    NSArray *results;
}

- (id)initWithLangDict:(NSDictionary *)langDict;

@end
