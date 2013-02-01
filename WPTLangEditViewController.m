//
//  WPTLangEditViewController.m
//  WPTrans
//
//  Created by Garrett Albright on 12/30/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import "WPTLangEditViewController.h"
#import "WPTLangBase.h"
#import "WPTLang.h"
#import "WPTLangSwitch.h"
#import "TSMiniWebBrowser.h"

@interface WPTLangEditViewController ()

@end

@implementation WPTLangEditViewController

- (void)viewWillAppear:(BOOL)animated {
    NSString *selectLangsText = NSLocalizedString(@"Select Languages", @"Title of language enable/disable screen.");
    [navBar setTitle:selectLangsText];
    [doneButton setAction:@selector(closeSelf)];
}

- (void)closeSelf
{
    [[WPTLangBase sharedBase] enabledLangsWasUpdated];
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait) || UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[WPTLangBase sharedBase] allLangs] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WPTLangEditViewControllerRow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    WPTLang *lang = [[[WPTLangBase sharedBase] allLangs] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[lang language]];
    WPTLangSwitch *langSwitch = [[WPTLangSwitch alloc] initWithLangcode:[lang langcode]];
    [langSwitch addTarget:langSwitch action:@selector(toggled) forControlEvents:UIControlEventValueChanged];
    [langSwitch setOn:[lang isEnabled]];
    [cell setAccessoryView:langSwitch];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPTLangBase *langBase = [WPTLangBase sharedBase];
    WPTLang *lang = [[langBase allLangs] objectAtIndex:[indexPath row]];
    NSDictionary *moreLangInfo = [langBase moreInfoForLang:lang];
    if (moreLangInfo) {
        // Create the title of the action sheet. In theory, this should look
        // like: "Native Language Name (English Language Name, Langcode)" (for
        // example, "Español (Spanish, es)"). However, there are problems with
        // RTL languages:
        // http://stackoverflow.com/questions/14471781/rtl-scripts-in-ios-action-sheets-unexpected-behavior
        NSString *title = [NSString stringWithFormat:NSLocalizedString(@"%1$@ (%2$@, %3$@)", @"Format of the language information that shows at the top of the action sheet when the user selects a language on the language edit table. Strings are: Native language name, English language name, language code."), [lang language], [moreLangInfo objectForKey:@"englishName"], [lang langcode]];
        NSString *viewText = NSLocalizedString(@"View Wikipedia", @"Button to view the front page of the Wikipedia for a given language.");
        NSString *cancelText = NSLocalizedString(@"Cancel", nil);
        [[[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancelText destructiveButtonTitle:nil otherButtonTitles: viewText, nil] showInView:[self view]];
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // "View Wikipedia" button
        // @todo This copies too much from WPTNewSearchViewController.m
        WPTLang *lang = [[[WPTLangBase sharedBase] allLangs] objectAtIndex:[[langTable indexPathForSelectedRow] row]];
        NSString *urlString = [NSString stringWithFormat:@"http://%@.m.wikipedia.org/wiki/", [lang langcode], nil];
        NSLog(@"%@", urlString);
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        TSMiniWebBrowser *browser = [[TSMiniWebBrowser alloc] initWithUrl:url];
        [browser setMode:TSMiniWebBrowserModeModal];
        [browser setShowReloadButton:NO];
        [self presentModalViewController:browser animated:TRUE];
    }
}

- (void)viewDidUnload {
    doneButton = nil;
    langTable = nil;
    navBar = nil;
    [super viewDidUnload];
}
@end
