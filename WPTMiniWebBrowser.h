//
//  WPTMiniWebBrowser.h
//  WPTrans
//
//  Created by Garrett Albright on 2/15/14.
//  Copyright (c) 2014 Garrett Albright. All rights reserved.
//

@interface WPTMiniWebBrowser : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
    UIWebView *webView;
}


- (WPTMiniWebBrowser *) initWithUrl: (NSURL *)url;
- (void)closeSelf;
- (void)actionButton;
- (NSString *)getWebViewPageTitle;

@end
