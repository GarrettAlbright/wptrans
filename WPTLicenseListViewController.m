//
//  WPTLicenseListViewController.m
//  WPTrans
//
//  Created by Garrett Albright on 2/13/14.
//  Copyright (c) 2014 Garrett Albright. All rights reserved.
//

#import "WPTLicenseListViewController.h"
#import "WPTLicenseViewController.h"

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
    return [licenseNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"WPTLicenseListViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [[cell textLabel] setText:[licenseNames objectAtIndex:[indexPath row]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPTLicenseViewController *licenseView = [[WPTLicenseViewController alloc] initWithLicenseInfo:[[self licenseDataFromPlist] objectAtIndex:[indexPath row]]];
    UINavigationController *licenseNavC = [[UINavigationController alloc] initWithRootViewController:licenseView];
    [self presentModalViewController:licenseNavC animated:YES];
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (NSArray *)licenseDataFromPlist {
    NSBundle *appBundle = [NSBundle mainBundle];
    NSString *fname = [appBundle pathForResource:@"licenses" ofType:@"plist"];
    return[[NSArray alloc] initWithContentsOfFile:fname];
}

@end
