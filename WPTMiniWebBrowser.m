//
//  WPTMiniWebBrowser.m
//  WPTrans
//
//  Created by Garrett Albright on 2/15/14.
//  Copyright (c) 2014 Garrett Albright. All rights reserved.
//

#import "WPTMiniWebBrowser.h"

@interface WPTMiniWebBrowser ()

@end

@implementation WPTMiniWebBrowser

- (WPTMiniWebBrowser *)initWithUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        CGRect bounds = [[self view] bounds];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeSelf)];
        [[self navigationItem] setRightBarButtonItem:doneButton];
        UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButton)];
        [[self navigationItem] setLeftBarButtonItem:actionButton];
        
        webView = [[UIWebView alloc] initWithFrame:bounds];
        [webView setDelegate:self];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [webView loadRequest:requestObj];
        [[self view] addSubview:webView];
    }
    return self;
}

- (void)closeSelf
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)actionButton
{
    NSString *cancelText = NSLocalizedString(@"Cancel", @"Allows user to cancel out of in-app browser action menu.");
    NSString *viewInSafariText = NSLocalizedString(@"View in Safari", @"Launches in-app browser's current page in Safari.");
    NSString *pageTitle = [self getWebViewPageTitle];
    [[[UIActionSheet alloc] initWithTitle:pageTitle delegate:self cancelButtonTitle:cancelText destructiveButtonTitle:nil otherButtonTitles:viewInSafariText, nil] showInView:[self view]];

}

-(NSString *)getWebViewPageTitle {
    return [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // View in Safari button
        [[UIApplication sharedApplication] openURL:[[webView request] URL]];

    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[self navigationItem] setTitle:[self getWebViewPageTitle]];
}

@end
