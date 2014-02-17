//
//  WPTNewLangEditViewController.m
//  WPTrans
//
//  Created by Garrett Albright on 2/17/14.
//  Copyright (c) 2014 Garrett Albright. All rights reserved.
//

#import "WPTNewLangEditViewController.h"
#import "WPTLangBase.h"
#import "WPTLangSwitch.h"
#import "WPTMiniWebBrowser.h"

@interface WPTNewLangEditViewController ()

@end

@implementation WPTNewLangEditViewController

- (WPTNewLangEditViewController *)init {
    self = [super init];
    if (self) {
        langTable = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [langTable setDelegate:self];
        [langTable setDataSource:self];
        NSString *infoText = NSLocalizedString(@"Select the languages you would like to search in and see search results for.", @"Message at top of langauge edit table.");
        // @see http://stackoverflow.com/questions/17888436/ios-get-height-nsstring
        CGSize maxSize = CGSizeMake([langTable bounds].size.width, 99999);
        CGSize infoTextSize = [infoText sizeWithFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] constrainedToSize:maxSize];
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [langTable bounds].size.width, infoTextSize.height)];
        [textView setEditable:NO];
        [textView setText:infoText];
        [langTable setTableHeaderView:textView];
        [[self view] addSubview:langTable];

        [[self navigationItem] setTitle:NSLocalizedString(@"Select Languages", @"Title of language enable/disable screen.")];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeSelf)];
        [[self navigationItem] setRightBarButtonItem:doneButton];

    }
    return self;
}

- (void)closeSelf
{
    [[WPTLangBase sharedBase] enabledLangsWasUpdated];
    [self dismissModalViewControllerAnimated:YES];
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
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        WPTMiniWebBrowser *browser = [[WPTMiniWebBrowser alloc] initWithUrl:url];
        UINavigationController *browserNavController = [[UINavigationController alloc] initWithRootViewController:browser];
        [self presentModalViewController:browserNavController animated:TRUE];
    }
}


@end
