//
//  ServerController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthViewController.h"
#import "CanAskConnectionDelegate.h"
#import "CategoriesConnectionDelegate.h"
#import "CoursesConnectionDelegate.h"
#import "CourseSelectionViewController.h"
#import "Course.h"
#import "DetailViewController.h"
#import "HalfViewController.h"
#import <Parse/Parse.h>
#import "QueueConnectionDelegate.h"
#import "RootViewController.h"
#import "ScheduleConnectionDelegate.h"
#import "ServerController.h"
#import "Token.h"
#import "TF.h"

@implementation ServerController

@synthesize course = _course;
@synthesize courseSelectionViewController = _courseSelectionViewController;
@synthesize halfViewController = _halfViewController;
@synthesize isFormPresent = _isFormPresent;
@synthesize navController = _navController;
@synthesize sessid = _sessid;
@synthesize suiteId = _suiteId;

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
            instance.isFormPresent = false;
            instance.courseSelectionViewController = [[CourseSelectionViewController alloc] init];
            instance.suiteId = 0;
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
    if (!self.sessid && !self.isFormPresent) {
        self.isFormPresent = true;
        self.navController = [[UINavigationController alloc] 
                              initWithRootViewController:self.courseSelectionViewController];
        [self getCourses];
        [self.halfViewController presentModalViewController:self.navController animated:YES];
        return NO;
    }
    
    return YES;
}

/**
 * Login form successfully authenticated
 *
 */
- (void)didAuthenticateWithSession:(NSString *)sessid
{
    [self.navController dismissModalViewControllerAnimated:YES];
    self.sessid = sessid;
    self.isFormPresent = NO;
    
    // unsubscribe from all existing channels
    for (NSString* c in [PFPush getSubscribedChannels:nil])
        [PFPush unsubscribeFromChannel:c withError:nil];
    
    // subscribe to push notification channel
    NSError* error;
    if (self.suiteId)
        [PFPush subscribeToChannel:[NSString stringWithFormat:@"queue_suite_id_%d", self.suiteId] withError:&error];
    
    if (!self.suiteId || error) {
        UIAlertView* a = [[UIAlertView alloc] initWithTitle:@"Uh oh"
                                                    message:@"An error occurred!!!"
                                                   delegate:nil
                                          cancelButtonTitle:@"Aww man"
                                          otherButtonTitles:nil];
        [a show];
    }
    
    [self refresh];
}

/**
 * Dispatch a student to a TF by POSTing to /questions/dispatch
 * @param question Question to be dispatched
 * @param tf TF/CA to which question will be dispatched
 *
 */
- (void)dispatchTokens:(NSArray*)tokens toTF:(TF*)tf;
{    
    if ([self authenticate]) {    
        // create comma separated list of question ids
        NSMutableString* tokenIds = [[NSMutableString alloc] initWithString:@"ids="];
        for (Token* t in tokens) {
            [tokenIds appendFormat:@"%d,", t.tokenId];
            [self.halfViewController.rootViewController.tokens removeObject:t];
        }
    
        // construct url
        NSURL* url = [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"discuss/tokens/dispatch"]];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSString* params = [NSString stringWithFormat:@"%@&staff_id=%d", tokenIds, tf.staffId];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", self.sessid] forHTTPHeaderField:@"Cookie"];
    
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:nil];
        [connection start];
    }
}

/**
 * Get whether or not students can ask questions
 *
 */
- (void)getCanAsk
{    
    if ([self authenticate]) {
        CanAskConnectionDelegate* d = [[CanAskConnectionDelegate alloc] init];
    
        NSURL* url = [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"discuss/status/queue/%d", self.suiteId]];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", self.sessid] forHTTPHeaderField:@"Cookie"];
        
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
        [connection start];
    }
}

/**
 * Get all of the possible labels for the suite
 *
 */
- (void)getLabels
{
    if ([self authenticate]) {
        CategoriesConnectionDelegate* d = [[CategoriesConnectionDelegate alloc] init];    
        
        // construct url
        NSURL* url = [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"discuss/labels/suite/%d", self.suiteId]];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", self.sessid] forHTTPHeaderField:@"Cookie"];
        
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
        [connection start];
    }
}

/**
 * Get all registered suites
 *
 */
- (void)getCourses
{
    CoursesConnectionDelegate* d = [[CoursesConnectionDelegate alloc] init];
    d.viewController = self.courseSelectionViewController;

    NSURL* url = [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"suites/all"]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
    [connection start];
}

/**
 * Get the current state of the queue
 *
 */
- (void)getQueue
{
    if ([self authenticate]) {        
        // create delegate to refresh question list
        QueueConnectionDelegate* d = [[QueueConnectionDelegate alloc] init];
        self.halfViewController.rootViewController.activityIndicator.hidden = NO;
    
        NSURL* url = [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"discuss/tokens/queue/%d", self.suiteId]];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@;", self.sessid] forHTTPHeaderField:@"Cookie"];
        
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
        [connection start];
    }
}

/**
 * Get the TFs/CAs scheduled to be on duty today
 *
 */
- (void)getSchedule
{    
    if ([self authenticate]) {
        // create delegate to display staff from response
        ScheduleConnectionDelegate* d = [[ScheduleConnectionDelegate alloc] init];    
    
        // construct url
        NSURL* url = [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"discuss/dispatches/staff/%d", self.suiteId]];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", self.sessid] forHTTPHeaderField:@"Cookie"];
        
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
        [connection start];
    }
}

/**
 * Notify a TF to finish up with a student
 *
 */
- (void)notifyTF:(TF*)tf;
{
    if ([self authenticate]) {
        NSURL* url = [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"discuss/dispatches/notify/%d/%d", tf.staffId, self.suiteId]];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", self.sessid] forHTTPHeaderField:@"Cookie"];
        
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:nil];
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
        [self getQueue];
        [self getLabels];
        [self getSchedule];
        [self getCanAsk];
    }
}

/**
 * Mark a TF as being here
 *
 */
- (void)setArrival:(TF*)tf
{
    if ([self authenticate]) {
        // construct url
        NSURL* url = [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"discuss/arrivals/user/%d", self.suiteId]];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
        NSString* params = [NSString stringWithFormat:@"user_id=%d", tf.staffId];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", self.sessid] forHTTPHeaderField:@"Cookie"];
        
        // send request
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:nil];
        [connection start];
    }
}

/**
 * Get whether or not students can ask questions
 *
 */
- (void)setCanAsk:(BOOL)canAsk
{    
    if ([self authenticate]) {
        // set up delegate to handle response
        CanAskConnectionDelegate* d = [[CanAskConnectionDelegate alloc] init];
        
        // construct url
        NSURL* url = [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"discuss/status/queue/%d", self.suiteId]];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
        // enable or disable the queue via POST variable
        NSString* params = [NSString stringWithFormat:@"state=%d", canAsk];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", self.sessid] forHTTPHeaderField:@"Cookie"];
        
        // send request
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
        [connection start];
    }
}

@end
