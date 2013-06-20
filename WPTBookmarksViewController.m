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
#import "WPTBookmarksBase.h"
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
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(startEdit)];
        [ni setRightBarButtonItem:editButton];
    }
    return self;
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[[WPTBookmarksBase sharedBase] allBookmarks] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[WPTBookmarksBase sharedBase] numberOfTermsInLanguageAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"WPTBookmarksViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [[cell textLabel] setText:[[WPTBookmarksBase sharedBase] getTermForIndexPath:indexPath]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *langcode = [[WPTBookmarksBase sharedBase] langcodeForIndex:section];
    NSString *langName = [[WPTLangBase sharedBase] languageForCode:langcode];
    return langName ? langName : langcode;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([[WPTBookmarksBase sharedBase] deleteSearchTermAtIndexPath:indexPath]) {
            if ([[self tableView] numberOfRowsInSection:[indexPath section]] == 1) {
                [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:[indexPath section]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else {
                [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait) || UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
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

- (void)startEdit
{
    [self setEditing:YES animated:YES];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(stopEdit)];
    [[self navigationItem] setRightBarButtonItem:editButton];
    
}

- (void)stopEdit
{
    [self setEditing:NO animated:YES];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(startEdit)];
    [[self navigationItem] setRightBarButtonItem:editButton];

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSString *langcode = [[WPTBookmarksBase sharedBase] langcodeForIndex:[indexPath section]];
    WPTLang *theLang = [[WPTLangBase sharedBase] langObjectForCode:langcode];
    NSString *term = [[WPTBookmarksBase sharedBase] getTermForIndexPath:indexPath];
    WPTNewSearchViewController *searchViewController = [[WPTNewSearchViewController alloc] initWithLang:theLang searchTerm:term];
    [[self navigationController] pushViewController:searchViewController animated:YES];
}

@end
