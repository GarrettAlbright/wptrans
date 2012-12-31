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
#import "WPTLangBase.h"

@interface WPTNewSearchViewController ()

@end

@implementation WPTNewSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithLang:(WPTLang *)lang
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        UINavigationItem *ni = [self navigationItem];
        [ni setTitle:[lang language]];
        langcode = [lang langcode];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [activityIndicator startAnimating];
    WPTWPRequest *req = [[WPTWPRequest alloc] initWithQueryTerm:[searchBar text] langcode:langcode thenCallSelector:@selector(retrieveResults:) onObject:self];
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


- (void)retrieveResults:(NSDictionary *)fullResults
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


@end