//
//  WPTLicenseViewController.m
//  WPTrans
//
//  Created by Garrett Albright on 2/13/14.
//  Copyright (c) 2014 Garrett Albright. All rights reserved.
//

#import "WPTLicenseViewController.h"

@implementation WPTLicenseViewController

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (WPTLicenseViewController *)initWithLicenseInfo:(NSDictionary *)licenseInfo
{
    self = [super init];
    UINavigationItem *ni = [self navigationItem];
    [ni setTitle:[licenseInfo objectForKey:@"name"]];
    UIBarButtonItem *doneBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeSelf)];
    [ni setRightBarButtonItem:doneBBI];
    UITextView *textView = [[UITextView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [textView setText:[licenseInfo objectForKey:@"license"]];
    [textView setEditable: NO];
    [[self view] addSubview:textView];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)closeSelf
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
