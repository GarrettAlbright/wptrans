//
//  WPTNewSearchViewController.m
//  WPTrans
//
//  Created by Garrett Albright on 12/30/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import "WPTNewSearchViewController.h"
#import "WPTLang.h"
#import "WPTWPRequest.h"
#import "WPTWPRequestDelegate.h"
#import "WPTLangBase.h"

@interface WPTNewSearchViewController ()

@end

@implementation WPTNewSearchViewController

- (id)initWithLang:(WPTLang *)lang searchTerm:(NSString *)initSearchTerm
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        UINavigationItem *ni = [self navigationItem];
        [ni setTitle:[lang language]];
        langcode = [lang langcode];
        searchTerm = initSearchTerm;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    // If the view appeared with a search term in the field, but no results,
    // then fire up the search and get results.
    if (searchTerm && results == nil) {
        [searchTermBar setText:searchTerm];
        [self startSearch];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastSearch"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return results ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WPTNewSearchViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    NSDictionary *result = [results objectAtIndex:[indexPath row]];
    [[cell detailTextLabel] setText:[result objectForKey:@"translation"]];
    [[cell textLabel] setText:[result objectForKey:@"language"]];
    return cell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self startSearch];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)startSearch
{
    // @todo Save search query as user data so that we can reload the search
    // at next start-up of this app if it appears it was suspended before the
    // search screen was closed.
    [activityIndicator startAnimating];
    NSString *searchTerm = [searchTermBar text];
    NSDictionary *lastSearch = [[NSDictionary alloc] initWithObjects:@[searchTerm, langcode] forKeys:@[@"searchTerm", @"langcode"]];
    [[NSUserDefaults standardUserDefaults] setObject:lastSearch forKey:@"lastSearch"];
    [[WPTWPRequest alloc] initWithQueryTerm:[searchTermBar text] langcode:langcode delegate:self];
}

- (void)wikipediaQueryResultsReceived:(NSDictionary *)fullResults
{
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"language" ascending:YES];
    NSMutableArray *filteredResults = [[NSMutableArray alloc] init];
    NSArray *enabledLangcodes = [[WPTLangBase sharedBase] enabledLangcodes];
    for (NSDictionary *result in [fullResults objectForKey:@"languageResults"]) {
        if ([enabledLangcodes containsObject:[result objectForKey:@"langcode"]]) {
            [filteredResults addObject:result];
        }
    }
    results = [filteredResults sortedArrayUsingDescriptors:[NSArray arrayWithObject:sorter]];
    NSString *finalTitle = [fullResults objectForKey:@"finalTitle"];
    if (finalTitle) {
        [searchTermBar setText:finalTitle];
    }
    [resultsTable reloadData];
    [activityIndicator stopAnimating];
}

-(void)wikipediaQueryDidCauseError:(NSError *)error
{
    [activityIndicator stopAnimating];
    // Set our own error strings for some cases; use the default for others
    NSString *errorMessage;
    switch ([error code]) {
        case -1003:
            // Server couldn't be accessed.
            errorMessage = @"Wikipedia could not be accessed. Please try again later.";
            break;
        case 3840:
            // JSON parsing broke.
            errorMessage = @"Wikipedia’s response could not be understood. Its servers may be experiencing some trouble. Please try again later.";
            break;
        default:
            errorMessage = [error localizedDescription];
            break;
    }
    [[[UIAlertView alloc] initWithTitle:@"Connection error" message:errorMessage delegate:self cancelButtonTitle: @"Cancel" otherButtonTitles:@"Try Again", nil] show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Was "Try Again" clicked?
    if (buttonIndex == 1) {
        [self startSearch];
    }
}

@end
