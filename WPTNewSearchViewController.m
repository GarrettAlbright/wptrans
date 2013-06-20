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
#import "WPTBookmarksBase.h"
#import "TSMiniWebBrowser.h"
#import "SVProgressHUD.h"

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
        // ProTip: The "Zed Shaw" article in the English Wikipedia currently has
        // no translations, so I like to use that for testing this message. I'm
        // sure there are others, but that's what I use for now.
        NSString *noTransFound = NSLocalizedString(@"No translations found.", @"Error message shown when no translations for a search term were found.");
        [[cell detailTextLabel] setText:noTransFound];
        // In the case of a search where there are translations found followed
        // by a search where no translations are found, the first cell will have
        // the previous first cell's textLabel text, apparently due to the whole
        // cell reuse thing. So let's manually empty it out.
        [[cell textLabel] setText:@""];
    }
    else {
        NSDictionary *result = [results objectAtIndex:[indexPath row]];
        [[cell detailTextLabel] setText:[result objectForKey:@"translation"]];
        [[cell textLabel] setText:[result objectForKey:@"language"]];
    }
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![results count]) {
        // If there were no results, we don't want rows to be selectable (we're
        // only showing the "No translations found" row anyway and don't want
        // to try to show the menu for that).
        return nil;
    }
    return indexPath;
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
    // @todo Does it make sense to empty out the table of results now instead of
    // waiting for the results from the server? Hmm.
    [SVProgressHUD show];
    NSString *currentSearchTerm = [searchTermBar text];
    NSDictionary *lastSearch = [[NSDictionary alloc] initWithObjects:@[currentSearchTerm, langcode] forKeys:@[@"searchTerm", @"langcode"]];
    [[NSUserDefaults standardUserDefaults] setObject:lastSearch forKey:@"lastSearch"];
    [[WPTWPRequest alloc] initWithQueryTerm:currentSearchTerm langcode:langcode delegate:self];
    searchTerm = currentSearchTerm;
}

- (void)wikipediaQueryResultsReceived:(NSDictionary *)fullResults
{
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"language" ascending:YES];
    NSMutableArray *filteredResults = [[NSMutableArray alloc] initWithCapacity:[fullResults count]];
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
        searchTerm = finalTitle;
    }
    [SVProgressHUD dismiss];
    [resultsTable reloadData];
    // @todo Don't re-add the bar button item if it's already added.
    UINavigationItem *ni = [self navigationItem];
    UIBarButtonItem *bookmarkButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookmarkCurrentTerm)];
    [ni setRightBarButtonItem:bookmarkButton];
}

- (void)wikipediaQueryDidCauseError:(NSError *)error
{
    [SVProgressHUD dismiss];
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
    [[self navigationItem] setRightBarButtonItem:nil];
}

- (void)bookmarkCurrentTerm
{
    [[WPTBookmarksBase sharedBase] addSearchTerm:searchTerm forLangcode:langcode];
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
        NSString *urlString = [NSString stringWithFormat:@"http://%@.m.wikipedia.org/wiki/%@", [result objectForKey:@"langcode"], [result objectForKey:@"translation"], nil];
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        TSMiniWebBrowser *browser = [[TSMiniWebBrowser alloc] initWithUrl:url];
        [browser setMode:TSMiniWebBrowserModeModal];
        [browser setShowReloadButton:NO];
        [self presentModalViewController:browser animated:TRUE];
    }
}

@end
