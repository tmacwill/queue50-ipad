//
//  ServerController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoriesConnectionDelegate.h"
#import "DetailViewController.h"
#import "DispatchConnectionDelegate.h"
#import "QueueConnectionDelegate.h"
#import "Question.h"
#import "RootViewController.h"
#import "ScheduleConnectionDelegate.h"
#import "ServerController.h"
#import "TF.h"

@implementation ServerController

@synthesize detailViewController=_detailViewController;
@synthesize filterViewController=_filterViewController;
@synthesize hasLoadedQueue=_hasLoadedQueue;
@synthesize rootViewController=_rootViewController;

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
            instance.hasLoadedQueue = false;
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
    // set up connection delegate
    TF* tf = [self.detailViewController.onDutyTFs objectAtIndex:indexPath.row];
    DispatchConnectionDelegate* d = [DispatchConnectionDelegate sharedInstance];
    d.rootViewController = self.rootViewController;
    d.detailViewController = self.detailViewController;
    d.tfIndexPath = indexPath;
    d.questionIndexPaths = self.rootViewController.selectedRows;
    
    // create comma separated 
    NSMutableString* questionsParam = [[NSMutableString alloc] initWithString:@"ids="];
    for (NSIndexPath* questionIndexPath in self.rootViewController.selectedRows) {
        Question* q = [self.rootViewController.questions objectAtIndex:questionIndexPath.row];
        [questionsParam appendFormat:@"%d,", q.questionId];
    }
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"questions/dispatch"]]];
    NSString* params = [NSString stringWithFormat:@"%@&tf=%@", questionsParam, tf.name];
    
    NSLog(@"%@", questionsParam);
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
    [connection start];
}

/**
 * Get the categories for today's OHs
 *
 */
- (void)getCategories
{
    CategoriesConnectionDelegate* d = [CategoriesConnectionDelegate sharedInstance];
    d.viewController = self.filterViewController;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"spreadsheets/categories"]]];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
    [connection start];
}

/**
 * Get the current state of the queue
 *
 */
- (void)getQueue
{
    QueueConnectionDelegate* d = [QueueConnectionDelegate sharedInstance];
    d.viewController = self.rootViewController;
    NSMutableString* url = [[NSMutableString alloc] initWithString:
                            [BASE_URL stringByAppendingString:@"questions/queue"]];
    
    // if we have not loaded the queue yet, force an immediate response
    if (!self.hasLoadedQueue)
        [url appendString:@"/true"];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:url]];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
    [connection start];
    self.hasLoadedQueue = true;
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
