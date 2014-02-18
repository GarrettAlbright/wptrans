//
//  WPTLicenseListViewController.m
//  WPTrans
//
//  Created by Garrett Albright on 2/13/14.
//  Copyright (c) 2014 Garrett Albright. All rights reserved.
//

#import "WPTLicenseListViewController.h"
#import "WPTLicenseViewController.h"
#import "WPTMiniWebBrowser.h"

@interface WPTLicenseListViewController ()

@end

@implementation WPTLicenseListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UINavigationItem *ni = [self navigationItem];
        NSString *selectLangText = NSLocalizedString(@"Licenses", @"Title of licenses screen.");
        [ni setTitle:selectLangText];
        
        NSArray *licenseData = [self licenseDataFromPlist];
        NSMutableArray *mutableLicenseNames = [[NSMutableArray alloc] initWithCapacity:[licenseData count]];
        for (NSDictionary *licenseInfo in licenseData) {
            [mutableLicenseNames addObject:[licenseInfo objectForKey:@"name"]];
        }
        licenseNames = mutableLicenseNames;
    }
    return self;
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//    // Uncomment the following line to preserve selection between presentations.
//    // self.clearsSelectionOnViewWillAppear = NO;
// 
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // Add one for the Wikimedia license
    return [licenseNames count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"WPTLicenseListViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // If it's the last cell, show the Wikimedia license; otherwise, use the
    // Wikimedia license
    NSString *cellText;
    if ([indexPath row] == [licenseNames count]) {
        cellText = NSLocalizedString(@"Wikimedia Foundation ToU", @"Title for the Wikimedia Foundation ToU row in the license list.");
    }
    else {
        cellText = [licenseNames objectAtIndex:[indexPath row]];
    }
    [[cell textLabel] setText:cellText];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *licenseView;
    if ([indexPath row] == [licenseNames count]) {
        licenseView = [[WPTMiniWebBrowser alloc] initWithUrl:[[NSURL alloc] initWithString:NSLocalizedString(@"http://m.wikimediafoundation.org/wiki/Terms_of_Use", @"URL of the mobile page for the Wikimedia ToU. If a localized page is available for the target language, use it instead.")]];
    }
    else {
        licenseView = [[WPTLicenseViewController alloc] initWithLicenseInfo:[[self licenseDataFromPlist] objectAtIndex:[indexPath row]]];
    }
    UINavigationController *licenseNavC = [[UINavigationController alloc] initWithRootViewController:licenseView];
    [self presentModalViewController:licenseNavC animated:YES];
}

- (NSArray *)licenseDataFromPlist {
    NSBundle *appBundle = [NSBundle mainBundle];
    NSString *fname = [appBundle pathForResource:@"licenses" ofType:@"plist"];
    return[[NSArray alloc] initWithContentsOfFile:fname];
}

@end
