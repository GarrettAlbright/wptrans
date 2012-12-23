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

@interface WPTLangSelViewController ()

@end

@implementation WPTLangSelViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        UINavigationItem *ni = [self navigationItem];
        [ni setTitle:@"Select Language"];
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!languageList) {
        // @todo Get list of languages. For now, we hard-code the ten Wiki
        // languages that have the most articles.
        NSMutableArray *list = [[NSMutableArray alloc] init];
        NSMutableDictionary *lang = [[NSMutableDictionary alloc] init];
        [lang setValue:@"English" forKey:@"loclang"];
        [lang setValue:@"en" forKey:@"prefix"];
        [list addObject:(NSDictionary *)lang];
        
        lang = [[NSMutableDictionary alloc] init];
        [lang setValue:@"Deutsch" forKey:@"loclang"];
        [lang setValue:@"de" forKey:@"prefix"];
        [list addObject:(NSDictionary *)lang];

        lang = [[NSMutableDictionary alloc] init];
        [lang setValue:@"Français" forKey:@"loclang"];
        [lang setValue:@"fr" forKey:@"prefix"];
        [list addObject:(NSDictionary *)lang];

        lang = [[NSMutableDictionary alloc] init];
        [lang setValue:@"Nederlands" forKey:@"loclang"];
        [lang setValue:@"nl" forKey:@"prefix"];
        [list addObject:(NSDictionary *)lang];

        lang = [[NSMutableDictionary alloc] init];
        [lang setValue:@"Italiano" forKey:@"loclang"];
        [lang setValue:@"it" forKey:@"prefix"];
        [list addObject:(NSDictionary *)lang];

        lang = [[NSMutableDictionary alloc] init];
        [lang setValue:@"Español" forKey:@"loclang"];
        [lang setValue:@"es" forKey:@"prefix"];
        [list addObject:(NSDictionary *)lang];

        lang = [[NSMutableDictionary alloc] init];
        [lang setValue:@"Русский" forKey:@"loclang"];
        [lang setValue:@"ru" forKey:@"prefix"];
        [list addObject:(NSDictionary *)lang];

        lang = [[NSMutableDictionary alloc] init];
        [lang setValue:@"Polski" forKey:@"loclang"];
        [lang setValue:@"pl" forKey:@"prefix"];
        [list addObject:(NSDictionary *)lang];

        lang = [[NSMutableDictionary alloc] init];
        [lang setValue:@"日本語" forKey:@"loclang"];
        [lang setValue:@"ja" forKey:@"prefix"];
        [list addObject:(NSDictionary *)lang];

        lang = [[NSMutableDictionary alloc] init];
        [lang setValue:@"Português" forKey:@"loclang"];
        [lang setValue:@"pt" forKey:@"prefix"];
        [list addObject:(NSDictionary *)lang];

        NSSortDescriptor *byLoclang = [NSSortDescriptor sortDescriptorWithKey:@"loclang" ascending:YES];
        languageList = [list sortedArrayUsingDescriptors:[NSArray arrayWithObject:byLoclang]];
//        // Load list of available languages. This is done by querying the
//        // English Wikipedia for the "Main Page" article. Since all available
//        // Wikipedia (Wikipedias?) will theroetically have a translation of this
//        // page, this is a way to get all "available" languages.
//        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//        WPTWPRequest *req = [[WPTWPRequest alloc] initWithQueryTerm:@"Main Page" langcode:@"en"];
//        // @todo This is probably a race condition
//        [nc addObserver:self selector:@selector(retrieveResults:) name:@"resultAvailable" object:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    return languageList ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [languageList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WPTLangSelViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    NSString *locLang = [[languageList objectAtIndex:[indexPath row]] objectForKey:@"loclang"];
//    NSLog(@"Translation is %@", translation);
    [[cell textLabel] setText:locLang];
    [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
//    [[cell textLabel] setText:[[languageList objectAtIndex:[indexPath row]] objectForKey:@"translation"]];
    
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
    NSDictionary *lang = [languageList objectAtIndex:[indexPath row]];
    WPTSearchViewController *searchViewController = [[WPTSearchViewController alloc] initWithLangDict:lang];
    [[self navigationController] pushViewController:searchViewController animated:YES];
}

@end
