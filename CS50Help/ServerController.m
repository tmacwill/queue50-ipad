//
//  ServerController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "QueueConnectionDelegate.h"
#import "Question.h"
#import "RootViewController.h"
#import "ScheduleConnectionDelegate.h"
#import "ServerController.h"
#import "TF.h"

@implementation ServerController

static ServerController* instance;

/**
 * Class is a singleton, get the only instance
 *
 */
+ (ServerController*)sharedInstance
{
    @synchronized(self) {
        if (!instance) {
            instance = [[ServerController alloc] init];
        }
    }
    
    return instance;
}

/**
 * Dispatch a student to a TF by POSTing to /questions/dispatch
 * @param question Question to be dispatched
 * @param tf TF/CA to which question will be dispatched
 *
 */
- (void)dispatchStudent:(Question*)student toTF:(TF*)tf
{
    
}

/**
 * Get the current state of the queue
 *
 */
- (void)getQueueForViewController:(RootViewController*)viewController
{
    QueueConnectionDelegate* d = [[QueueConnectionDelegate alloc] init];
    d.viewController = viewController;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"questions/queue/true"]]];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
    [connection start];
   
}

/**
 * Get the TFs/CAs scheduled to be on duty today
 *
 */
- (void)getScheduleForViewController:(DetailViewController*)viewController
{
    
    ScheduleConnectionDelegate* d = [[ScheduleConnectionDelegate alloc] init];
    d.viewController = viewController;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"spreadsheets/schedule"]]];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
    [connection start];
}

@end
