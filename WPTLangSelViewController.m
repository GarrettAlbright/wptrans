//
//  WPTLangSelectViewController.m
//  WPTrans
//
//  Created by Garrett Albright on 12/2/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import "WPTLangSelViewController.h"
#import "WPTWPRequest.h"
#import "WPTNewSearchViewController.h"
#import "WPTLangEditViewController.h"
#import "WPTBookmarksViewController.h"
#import "WPTLangBase.h"
#import "WPTLang.h"
#import "WPTLicenseListViewController.h"

@interface WPTLangSelViewController ()

@end

@implementation WPTLangSelViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UINavigationItem *ni = [self navigationItem];
        NSString *selectLangText = NSLocalizedString(@"Select Language", @"Title of search language selection screen.");
        [ni setTitle:selectLangText];
        // It stumped me for a while, but not having the colon after
        // "toEditScreen" below is correct. Why? I'm not sure.
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toEditScreen)];
        [ni setRightBarButtonItem:editButton];
        UIBarButtonItem *bookmarksButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(toBookmarksScreen)];
        [ni setLeftBarButtonItem:bookmarksButton];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Reload the table data, since this might be appearing after the list of
    // enabled languages was changed.
    [[self tableView] reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSDictionary *lastSearch = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastSearch"];
    if (lastSearch) {
        WPTLang *lang = [[WPTLangBase sharedBase] langObjectForCode:[lastSearch objectForKey:@"langcode"]];
        if (lang) {
            WPTNewSearchViewController *searchViewController = [[WPTNewSearchViewController alloc] initWithLang:lang searchTerm:[lastSearch objectForKey:@"searchTerm"]];
            [[self navigationController] pushViewController:searchViewController animated:YES];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait) || UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return section == 0 ? [[[WPTLangBase sharedBase] enabledLangs] count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"WPTLangSelViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if ([indexPath section] == 0) {
        WPTLang *lang = [[[WPTLangBase sharedBase] enabledLangs] objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[lang language]];
    }
    else {
        [[cell textLabel] setText:@"License information"];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        WPTLang *lang = [[[WPTLangBase sharedBase] enabledLangs] objectAtIndex:[indexPath row]];
        WPTNewSearchViewController *searchViewController = [[WPTNewSearchViewController alloc] initWithLang:lang searchTerm:nil];
        [[self navigationController] pushViewController:searchViewController animated:YES];
    }
    else {
        WPTLicenseListViewController *licenseListViewController = [[WPTLicenseListViewController alloc] init];
        [[self navigationController] pushViewController:licenseListViewController animated:YES];
    }
}

- (void)toEditScreen
{
    WPTLangEditViewController *editViewController = [[WPTLangEditViewController alloc] init];
    [self presentModalViewController:editViewController animated:YES];
}

- (void)toBookmarksScreen
{
    WPTBookmarksViewController *bookmarksViewController = [[WPTBookmarksViewController alloc] init];
    [[self navigationController] pushViewController:bookmarksViewController animated:YES];
}

@end
