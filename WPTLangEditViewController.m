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

@interface WPTLangEditViewController ()

@end

@implementation WPTLangEditViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NSString *selectLangsText = NSLocalizedString(@"Select Languages", @"Title of language enable/disable screen.");
        [[self navigationItem] setTitle:selectLangsText];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[WPTLangBase sharedBase] enabledLangsWasUpdated];
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

@end
