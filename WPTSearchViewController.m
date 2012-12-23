//
//  WPTSearchViewController.m
//  WPTrans
//
//  Created by Garrett Albright on 12/20/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import "WPTSearchViewController.h"
#import "WPTWPRequest.h"

@interface WPTSearchViewController ()

@end

@implementation WPTSearchViewController

- (id)initWithLangDict:(NSDictionary *)langDict
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        UINavigationItem *ni = [self navigationItem];
        [ni setTitle:[langDict objectForKey:@"lang"]];
        langPrefix = [langDict objectForKey:@"prefix"];
    }
    return self;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self becomeFirstResponder];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return results ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WPTSearchViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    NSDictionary *result = [results objectAtIndex:[indexPath row]];
    [[cell detailTextLabel] setText:[result objectForKey:@"translation"]];
    [[cell textLabel] setText:[result objectForKey:@"langcode"]];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    WPTWPRequest *req = [[WPTWPRequest alloc] initWithQueryTerm:searchString langcode:langPrefix];
//    // @todo This is probably a race condition
//    [nc addObserver:self selector:@selector(retrieveResults:) name:@"resultAvailable" object:req];
    
    // Return YES to cause the search result table view to be reloaded.
    return NO;
}


- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    NSLog(@"WillBegin", nil);
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    NSLog(@"WillEnd", nil);
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"EndEditing");
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    WPTWPRequest *req = [[WPTWPRequest alloc] initWithQueryTerm:[searchBar text] langcode:langPrefix thenCallSelector:@selector(retrieveResults:) onObject:self];
    // @todo This is probably a race condition
    [nc addObserver:self selector:@selector(retrieveResults:) name:@"resultAvailable" object:nil];
}

- (void)retrieveResults:(NSDictionary *)fullResults
{
    results = [fullResults objectForKey:@"languageResults"];
    NSString *finalTitle = [fullResults objectForKey:@"finalTitle"];
    if (finalTitle) {
        [[[self searchDisplayController] searchBar] setText:finalTitle];
    }
    // Note that [self tableView] doesn't work here
    [[[self searchDisplayController] searchResultsTableView] reloadData];
}

@end
