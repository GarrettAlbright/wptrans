//
//  WPTLangSelectViewController.m
//  WPTrans
//
//  Created by Garrett Albright on 12/2/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import "WPTLangSelViewController.h"
#import "WPTWPRequest.h"
#import "WPTSearchViewController.h"
#import "WPTLangEditViewController.h"
#import "WPTLangBase.h"
#import "WPTLang.h"

@interface WPTLangSelViewController ()

@end

@implementation WPTLangSelViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UINavigationItem *ni = [self navigationItem];
        [ni setTitle:@"Language"];
        // It stumped me for a while, but not having the colon after
        // "toEditScreen" below is correct. Why? I'm not sure.
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toEditScreen)];
        [ni setRightBarButtonItem:editButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Reload the table data, since this might be appearing after the list of
    // enabled languages was changed.
    [[self tableView] reloadData];
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
    return [[WPTLangBase sharedBase] enabledLangs] ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[WPTLangBase sharedBase] enabledLangs] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"WPTLangSelViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    WPTLang *lang = [[[WPTLangBase sharedBase] enabledLangs] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[lang language]];
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    return cell;
}


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
    WPTLang *lang = [[[WPTLangBase sharedBase] enabledLangs] objectAtIndex:[indexPath row]];
    WPTSearchViewController *searchViewController = [[WPTSearchViewController alloc] initWithLang:lang];
    [[self navigationController] pushViewController:searchViewController animated:YES];
}

- (void)toEditScreen
{
    WPTLangEditViewController *editViewController = [[WPTLangEditViewController alloc] init];
    [[self navigationController] pushViewController:editViewController animated:YES];
}

@end
