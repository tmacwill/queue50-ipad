//
//  ServerController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "DispatchConnectionDelegate.h"
#import "QueueConnectionDelegate.h"
#import "Question.h"
#import "RootViewController.h"
#import "ScheduleConnectionDelegate.h"
#import "ServerController.h"
#import "TF.h"

@implementation ServerController

@synthesize detailViewController=_detailViewController, rootViewController=_rootViewController;

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
- (void)dispatchQuestionsToTFAtIndexPath:(NSIndexPath*)indexPath;
{    
    TF* tf = [self.detailViewController.onDutyTFs objectAtIndex:indexPath.row];
    DispatchConnectionDelegate* d = [DispatchConnectionDelegate sharedInstance];
    d.rootViewController = self.rootViewController;
    d.detailViewController = self.detailViewController;
    d.tfIndexPath = indexPath;

    for (NSIndexPath* questionIndexPath in self.rootViewController.selectedRows) {
        Question* q = [self.rootViewController.questions objectAtIndex:questionIndexPath.row];
        d.questionIndexPath = questionIndexPath;

        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"questions/dispatch"]]];
        NSString* params = [NSString stringWithFormat:@"id=%d&tf=%@", q.questionId, tf.name];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
        
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
        [connection start];
    }

}

/**
 * Get the current state of the queue
 *
 */
- (void)getQueue
{
    QueueConnectionDelegate* d = [QueueConnectionDelegate sharedInstance];
    d.viewController = self.rootViewController;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"questions/queue/true"]]];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
    [connection start];
   
}

/**
 * Get the TFs/CAs scheduled to be on duty today
 *
 */
- (void)getSchedule
{
    ScheduleConnectionDelegate* d = [ScheduleConnectionDelegate sharedInstance];
    d.viewController = self.detailViewController;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"spreadsheets/schedule"]]];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
    [connection start];
}

@end
