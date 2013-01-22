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
#import "TSMiniWebBrowser.h"

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait) || UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return results ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger count = [results count];
    if (count == 0) {
        // Return 1, since we're going to show our "no results" row.
        return 1;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WPTNewSearchViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    NSInteger index = [indexPath row];
    if (index == 0 && [results count] == 0) {
        // Show the "no results" message.
        NSString *noTransFound = NSLocalizedString(@"No translations found.", @"Error message shown when no translations for a search term were found.");
        [[cell detailTextLabel] setText:noTransFound];
    }
    else {
        NSDictionary *result = [results objectAtIndex:[indexPath row]];
        [[cell detailTextLabel] setText:[result objectForKey:@"translation"]];
        [[cell textLabel] setText:[result objectForKey:@"language"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *result = [results objectAtIndex:[indexPath row]];
    NSString *cancelText = NSLocalizedString(@"Cancel", @"Allows user to cancel out of menu shown when search result is selected.");
    NSString *copyText = NSLocalizedString(@"Copy", @"Allows user to copy search result to clipboard.");
    NSString *viewArticleText = NSLocalizedString(@"View Article", @"Launches search result's corresponding Wikipedia article in the browser.");
    [[[UIActionSheet alloc] initWithTitle:[result objectForKey:@"translation"] delegate:self cancelButtonTitle:cancelText destructiveButtonTitle:nil otherButtonTitles:copyText, viewArticleText, nil] showInView:[self view]];
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
    NSString *currentSearchTerm = [searchTermBar text];
    NSDictionary *lastSearch = [[NSDictionary alloc] initWithObjects:@[currentSearchTerm, langcode] forKeys:@[@"searchTerm", @"langcode"]];
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

- (void)wikipediaQueryDidCauseError:(NSError *)error
{
    [activityIndicator stopAnimating];
    // Set our own error strings for some cases; use the default for others
    // @todo Should probably be checking domain too, not just code…
    NSString *errorMessage;
    switch ([error code]) {
        case -1003:
            // Server couldn't be accessed.
            errorMessage = NSLocalizedString(@"Wikipedia could not be accessed. Please try again later.", @"Body of error message shown when the Wikipedia server is not accessible.");
            break;
        case 3840:
            // JSON parsing broke.
            errorMessage = NSLocalizedString(@"Wikipedia’s response could not be understood. Its servers may be experiencing some trouble. Please try again later.", @"Body of error message shown when the Wikipedia server's response could not be parsed.");
            break;
        case 404:
            // No article found.
            errorMessage = NSLocalizedString(@"An article with that title could not be found. Please check your typing and try again.", @"Body of error message shown when an article cannot be found.");
            break;
        default:
            errorMessage = [error localizedDescription];
            break;
    }
    NSString *errorTitleText = NSLocalizedString(@"Article Search Error", @"Title of error window shown when a problem occurs when searching for a Wikipedia article.");
    NSString *cancelText = NSLocalizedString(@"Cancel", @"Title of cancel button in Wikipedia server connection error window.");
    NSString *tryAgainText = NSLocalizedString(@"Try Again", @"Title of try again button in Wikipedia server connection error window.");
    [[[UIAlertView alloc] initWithTitle:errorTitleText message:errorMessage delegate:self cancelButtonTitle:cancelText otherButtonTitles:tryAgainText, nil] show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Was "Try Again" clicked?
    if (buttonIndex == 1) {
        [self startSearch];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSDictionary *result = [results objectAtIndex:[[resultsTable indexPathForSelectedRow] row]];
    if (buttonIndex == 0) {
        // "Copy" button
        [[UIPasteboard generalPasteboard] setString:[result objectForKey:@"translation"]];
    }
    else if (buttonIndex == 1) {
        NSString *urlString = [NSString stringWithFormat:@"http://%@.wikipedia.org/wiki/%@", [result objectForKey:@"langcode"], [result objectForKey:@"translation"], nil];
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        TSMiniWebBrowser *browser = [[TSMiniWebBrowser alloc] initWithUrl:url];
        [browser setMode:TSMiniWebBrowserModeModal];
        [browser setShowReloadButton:NO];
        [self presentModalViewController:browser animated:TRUE];
    }
}

@end
