//
//  WPTAppDelegate.m
//  WPTrans
//
//  Created by Garrett Albright on 12/2/12.
//  Copyright (c) 2012 Garrett Albright. All rights reserved.
//

#import "WPTAppDelegate.h"
#import "WPTLangSelViewController.h"

@implementation WPTAppDelegate

+ (void)initialize
{
    // The default available languages. This list was constructed by selecting
    // the top twenty languages by speakers (note that's *total* speakers, not
    // *native* speakers) from the list at
    // http://www.ethnologue.org/ethno_docs/distribution.asp?by=size which
    // itself is a source on the Wikipedia article "List of languages by total
    // number of speakers." Each language was then inexpertly matched up with
    // the Wikipedia language code equivalent. The list is flawed for our use
    // case, since:
    // - "Speakers" is not necessarily equivalent to "readers"
    // - The actual usage data for those that use this app will probably differ
    //   (perhaps more people are using this app to look up words in Dutch or
    //   Swahili than Telugu and Tamil)
    // - Probably many other reasons I have yet to consider
    // …but for the lack of any other better lists at the moment, here we go.
    NSArray *defaultLangs = [[NSArray alloc] initWithObjects:
                             @"zh", // Chinese
                             @"es", // Spanish
                             @"en", // English
                             @"ar", // Arabic
                             @"hi", // Hindi
                             @"bn", // Bengali
                             @"pt", // Portuguese
                             @"ru", // Russian
                             @"ja", // Japanese
                             @"de", // German
                             @"jv", // Javanese
                             @"pa", // Punjabi
                             @"te", // Telugu
                             @"vi", // Vietnamese
                             @"mr", // Marathi
                             @"fr", // French
                             @"ko", // Korean
                             @"ta", // Tamil
                             @"it", // Italian
                             @"ur", // Urdu
                             nil];
    NSDictionary *defaults = [NSDictionary dictionaryWithObject:defaultLangs forKey:@"enabledLanguages"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    WPTLangSelViewController *wls = [[WPTLangSelViewController alloc] init];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:wls];
    [[self window] setRootViewController:navc];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
