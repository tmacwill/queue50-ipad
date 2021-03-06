//
//  CS50HelpAppDelegate.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CS50HelpAppDelegate.h"
#import "DetailViewController.h"
#import "HalfViewController.h"
#import <Parse/Parse.h>
#import "RootViewController.h"
#import "ServerController.h"

@implementation CS50HelpAppDelegate

@synthesize halfViewController = _halfViewController;
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // register for push notifications
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.halfViewController = [[HalfViewController alloc] init];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    self.window.rootViewController = self.halfViewController;
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
    serverController.halfViewController = self.halfViewController;
            
    [serverController refresh];
    
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

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)newDeviceToken
{
    // send device token to parse
    [PFPush storeDeviceToken:newDeviceToken];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    // refresh the queue
    if ([[userInfo valueForKey:@"type"] isEqualToString:@"refresh"]) {
        [[ServerController sharedInstance] getQueue];
    }
    
    // staff has become available
    else if ([[userInfo valueForKey:@"type"] isEqualToString:@"available"]) {
        int staffId = [[userInfo valueForKey:@"user_id"] intValue];
        [self.halfViewController.detailViewController dispatchCompleteForTF:staffId];
    }
    
    // staff has snoozed
    else if ([[userInfo valueForKey:@"type"] isEqualToString:@"snooze"]) {
        int staffId = [[userInfo valueForKey:@"user_id"] intValue];
        [self.halfViewController.detailViewController snoozeTF:staffId];
    }
}

@end
