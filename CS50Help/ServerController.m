//
//  ServerController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthViewController.h"
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

@synthesize authViewController=_authViewController;
@synthesize detailViewController=_detailViewController;
@synthesize filterViewController=_filterViewController;
@synthesize hasLoadedQueue=_hasLoadedQueue;
@synthesize isFormPresent=_isFormPresent;
@synthesize rootViewController=_rootViewController;
@synthesize user=_user;

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
            instance.isFormPresent = false;
            instance.authViewController = [[AuthViewController alloc] init];
        }
    }
    
    return instance;
}

/**
 * Check if user is authenticated and show login if not
 * @return YES if authenticated, NO if not
 *
 */
- (BOOL)authenticate
{
    // show login form if user is not authenticated
    if (!self.user && !self.isFormPresent) {
        self.isFormPresent = true;
        self.authViewController.delegate = self;
        [self.detailViewController presentModalViewController:self.authViewController animated:YES];
        return NO;
    }
    
    return YES;
}

/**
 * Login form successfully authenticated
 *
 */
- (void)didAuthenticateWithUser:(NSDictionary *)user
{
    [self.authViewController dismissModalViewControllerAnimated:YES];
    self.user = user;
    self.isFormPresent = NO;
    [self refresh];
}

/**
 * Dispatch a student to a TF by POSTing to /questions/dispatch
 * @param question Question to be dispatched
 * @param tf TF/CA to which question will be dispatched
 *
 */
- (void)dispatchQuestionsToTFAtIndexPath:(NSIndexPath*)indexPath;
{    
    if ([self authenticate]) {
        // set up connection delegate
        TF* tf = [self.detailViewController.onDutyTFs objectAtIndex:indexPath.row];
        DispatchConnectionDelegate* d = [[DispatchConnectionDelegate alloc] init];
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
        request.HTTPMethod = @"POST";
        request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", [self.user valueForKey:@"sessid"]]
                                  forHTTPHeaderField:@"Cookie"];
    
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
        [connection start];
    }
}

/**
 * Get the categories for today's OHs
 *
 */
- (void)getCategories
{    
    if ([self authenticate]) {
        CategoriesConnectionDelegate* d = [[CategoriesConnectionDelegate alloc] init];
        d.viewController = self.filterViewController;
    
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:
                                         [BASE_URL stringByAppendingFormat:@"spreadsheets/categories"]]];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", [self.user valueForKey:@"sessid"]]
                                  forHTTPHeaderField:@"Cookie"];
        
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
    if ([self authenticate]) {
        QueueConnectionDelegate* d = [QueueConnectionDelegate sharedInstance];
        d.viewController = self.rootViewController;
        NSMutableString* url = [[NSMutableString alloc] initWithString:
                                [BASE_URL stringByAppendingString:@"questions/queue"]];
    
        // if we have not loaded the queue yet, force an immediate response
        if (!self.hasLoadedQueue)
            [url appendString:@"/true"];
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:url]];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@;", [self.user valueForKey:@"sessid"]]
                                  forHTTPHeaderField:@"Cookie"];
        
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
        [connection start];
        self.hasLoadedQueue = true;
    }
}

/**
 * Get the TFs/CAs scheduled to be on duty today
 *
 */
- (void)getSchedule
{    
    if ([self authenticate]) {
        ScheduleConnectionDelegate* d = [[ScheduleConnectionDelegate alloc] init];
        d.viewController = self.detailViewController;
    
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:
                                         [BASE_URL stringByAppendingFormat:@"spreadsheets/schedule"]]];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", [self.user valueForKey:@"sessid"]]
                                  forHTTPHeaderField:@"Cookie"];
        
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
        [connection start];
    }
}

/**
 * Refresh server data only if authenticated
 *
 */
- (void)refresh
{
    if ([self authenticate]) {
        [self getCategories];
        [self getSchedule];
        [self getQueue];
    }
}

@end
