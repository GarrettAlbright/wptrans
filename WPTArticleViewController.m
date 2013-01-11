//
//  WPTArticleViewController.m
//  WPTrans
//
//  Created by Garrett Albright on 1/11/13.
//  Copyright (c) 2013 Garrett Albright. All rights reserved.
//

#import "WPTArticleViewController.h"

@interface WPTArticleViewController ()

@end

@implementation WPTArticleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(id)initWithRequest: (NSURLRequest *)request {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        // If we try to get the webView to load the request now, it won't work.
        // I guess it's too early. Save it for later.
        requestToLoad = request;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Load that web request we saved earlier.
    [webView loadRequest:requestToLoad];
    requestToLoad = nil;
    // Add actions to the toolbar buttons.
    [doneButton setAction:@selector(closeSelf)];
    [actionButton setAction:@selector(showActionMenu)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    webView = nil;
    doneButton = nil;
    actionButton = nil;
    [super viewDidUnload];
}

-(void)closeSelf
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)showActionMenu
{
    NSString *openInSafariText = NSLocalizedString(@"Open in Safari", @"Button in in-app browser which opens the current page in Safari.");
    NSString *copyUrlText = NSLocalizedString(@"Copy URL", @"Button in in-app browser which copies the URL of the current page to the clipboard.");
    NSString *cancelText = NSLocalizedString(@"Cancel", @"Button in in-app browser which cancels out of the action menu.");
    [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:cancelText destructiveButtonTitle:nil otherButtonTitles:openInSafariText, copyUrlText, nil] showInView:[self view]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSURL *currentUrl = [[webView request] URL];
    if (buttonIndex == 0) {
        // "Open in Safari" button
        [[UIApplication sharedApplication] openURL:currentUrl];
    }
    else if (buttonIndex == 1) {
        // "Copy URL" button
        [[UIPasteboard generalPasteboard] setString:[currentUrl absoluteString]];
    }
}

@end
