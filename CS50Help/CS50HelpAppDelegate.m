//
//  CS50HelpAppDelegate.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CS50HelpAppDelegate.h"
#import "FilterViewController.h"
#import "DetailViewController.h"
#import "RootViewController.h"
#import "ServerController.h"

@implementation CS50HelpAppDelegate

@synthesize detailViewController=_detailViewController;
@synthesize filterViewController=_filterViewController;
@synthesize rootViewController=_rootViewController;
@synthesize splitViewController = _splitViewController;
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    RootViewController *controller = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];

    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    self.filterViewController = [[FilterViewController alloc] init];
    controller.filterViewController = self.filterViewController;

    self.splitViewController = [[UISplitViewController alloc] init];
    self.splitViewController.delegate = detailViewController;
    self.rootViewController = controller;
    self.detailViewController = detailViewController;
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:navigationController, detailViewController, nil];
    self.window.rootViewController = self.splitViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    ServerController* serverController = [ServerController sharedInstance];
    serverController.detailViewController = self.detailViewController;
    serverController.filterViewController = self.filterViewController;
    serverController.rootViewController = self.rootViewController;
    
    [serverController getCategories];
    [serverController getSchedule];
    [serverController getQueue];
    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
