//
//  WPTArticleViewController.h
//  WPTrans
//
//  Created by Garrett Albright on 1/11/13.
//  Copyright (c) 2013 Garrett Albright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPTArticleViewController : UIViewController <UIActionSheetDelegate>
{

    __weak IBOutlet UIWebView *webView;
    __weak IBOutlet UIBarButtonItem *doneButton;
    __weak IBOutlet UIBarButtonItem *actionButton;
    NSURLRequest *requestToLoad;
}

-(id)initWithRequest: (NSURLRequest *)request;

@end
