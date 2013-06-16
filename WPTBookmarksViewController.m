//
//  WPTBookmarksViewController.m
//  WPTrans
//
//  Created by Garrett Albright on 6/16/13.
//  Copyright (c) 2013 Garrett Albright. All rights reserved.
//

// @todo Some sort of easier way to map indexPaths to langcodes and/or terms in
// the bookmark list. We're doing a lot of repetitive stuff to get that info
// everywhere we need it.

#import "WPTBookmarksViewController.h"
#import "WPTLangBase.h"
#import "WPTLang.h"
#import "WPTNewSearchViewController.h"

@interface WPTBookmarksViewController ()

@end

@implementation WPTBookmarksViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UINavigationItem *ni = [self navigationItem];
        NSString *selectLangText = NSLocalizedString(@"Bookmarks", @"Title of bookmarks screen.");
        [ni setTitle:selectLangText];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *unsortedBookmarks = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookmarks"];
    NSMutableDictionary *sortedBookmarks = [[NSMutableDictionary alloc] initWithCapacity:[unsortedBookmarks count]];
    for (NSString *langcode in [[unsortedBookmarks allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
        NSArray *terms = [unsortedBookmarks objectForKey:langcode];
        if ([terms count]) {
            [sortedBookmarks setValue:[terms sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] forKey:langcode];
        }
    }
    _theBookmarks = [NSDictionary dictionaryWithDictionary:sortedBookmarks];

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
    return [_theBookmarks count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[_theBookmarks objectForKey:[[_theBookmarks allKeys] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"WPTBookmarksViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *term = [[_theBookmarks objectForKey:[[_theBookmarks allKeys] objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:term];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *langcode = [[_theBookmarks allKeys] objectAtIndex:section];
    NSString *langName = [[WPTLangBase sharedBase] languageForCode:langcode];
    return langName ? langName : langcode;
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
    NSString *langcode = [[_theBookmarks allKeys] objectAtIndex:[indexPath section]];
    WPTLang *theLang = [[WPTLangBase sharedBase] langObjectForCode:langcode];
    NSString *term = [[_theBookmarks objectForKey:langcode] objectAtIndex:[indexPath row]];
    WPTNewSearchViewController *searchViewController = [[WPTNewSearchViewController alloc] initWithLang:theLang searchTerm:term];
    [[self navigationController] pushViewController:searchViewController animated:YES];
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
