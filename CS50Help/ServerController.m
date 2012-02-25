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
#import "DispatchConnectionDelegate.h"
#import "HalfViewController.h"
#import "QueueConnectionDelegate.h"
#import "Question.h"
#import "RootViewController.h"
#import "ScheduleConnectionDelegate.h"
#import "ServerController.h"
#import "TF.h"

@implementation ServerController

@synthesize course = _course;
@synthesize courseSelectionViewController = _courseSelectionViewController;
@synthesize halfViewController = _halfViewController;
@synthesize hasLoadedQueue = _hasLoadedQueue;
@synthesize isFormPresent = _isFormPresent;
@synthesize navController = _navController;
@synthesize url = _url;
@synthesize user = _user;

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
            instance.courseSelectionViewController = [[CourseSelectionViewController alloc] init];
            instance.url = [[NSMutableString alloc] initWithString:BASE_URL];
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
- (void)didAuthenticateWithUser:(NSDictionary*)user inCourse:(Course*)course
{
    [self.navController dismissModalViewControllerAnimated:YES];
    self.user = user;
    self.course = course;
    self.isFormPresent = NO;
    [self.url appendFormat:@"%@/", course.url];
    [self refresh];
}

/**
 * Dispatch a student to a TF by POSTing to /questions/dispatch
 * @param question Question to be dispatched
 * @param tf TF/CA to which question will be dispatched
 *
 */
- (void)dispatchQuestionsToTF:(TF*)tf;
{    
    //if ([self authenticate]) {
        // set up connection delegate
        DispatchConnectionDelegate* d = [[DispatchConnectionDelegate alloc] init];
    
        // create comma separated list of question ids
        NSMutableString* questionsParam = [[NSMutableString alloc] initWithString:@"ids="];
        for (Question* q in self.halfViewController.rootViewController.selectedQuestions) {
            [questionsParam appendFormat:@"%d,", q.questionId];
            [self.halfViewController.rootViewController.questions removeObject:q];
        }
    
        NSMutableString* url = [[NSMutableString alloc] initWithString:@"http://dev/questions/dispatch"];
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] 
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSString* params = [NSString stringWithFormat:@"%@&staff_id=%d", questionsParam, tf.staffId];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", [self.user valueForKey:@"sessid"]] forHTTPHeaderField:@"Cookie"];
    
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
        [connection start];
        
        // remove selected questions from the left panel for maximum UI responsiveness!
        [self.halfViewController.rootViewController buildVisibleQuestions];
        [self.halfViewController.rootViewController.selectedQuestions removeAllObjects];
        
        // place TF at bottom of list
        [self.halfViewController.detailViewController.onDutyTFs removeObject:tf];
        [self.halfViewController.detailViewController.onDutyTFs addObject:tf];
    //}
}

/**
 * Get whether or not students can ask questions
 *
 */
- (void)getCanAsk
{    
    //if ([self authenticate]) {
        CanAskConnectionDelegate* d = [[CanAskConnectionDelegate alloc] init];
        NSMutableString* url = [[NSMutableString alloc] initWithString:@"http://dev/questions/queueEnabled/1"];
    
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", [self.user valueForKey:@"sessid"]] forHTTPHeaderField:@"Cookie"];
        
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
        [connection start];
    //}
}

/**
 * Get the categories for today's OHs
 *
 */
- (void)getCategories
{    
    if ([self authenticate]) {
        CategoriesConnectionDelegate* d = [[CategoriesConnectionDelegate alloc] init];
        d.viewController = self.halfViewController.filterViewController;
    
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:
                                         [self.url stringByAppendingFormat:@"api/v1/categories/today"]]];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", [self.user valueForKey:@"sessid"]] forHTTPHeaderField:@"Cookie"];
        
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
        [connection start];
    }
}

/**
 * Get all registered courses
 *
 */
- (void)getCourses
{
    CoursesConnectionDelegate* d = [[CoursesConnectionDelegate alloc] init];
    d.viewController = self.courseSelectionViewController;
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:
                                     [self.url stringByAppendingFormat:@"a/api/v1/courses/all"]]];
    
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
    [connection start];
    
}

/**
 * Get the current state of the queue
 *
 */
- (void)getQueue
{
    //if ([self authenticate]) {
        QueueConnectionDelegate* d = [QueueConnectionDelegate sharedInstance];    
        NSMutableString* url = [[NSMutableString alloc] initWithString:@"http://dev/questions/queue/1"];
            
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] 
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@;", [self.user valueForKey:@"sessid"]] forHTTPHeaderField:@"Cookie"];
        
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
        [connection start];
        self.hasLoadedQueue = true;
    //}
}

/**
 * Get the TFs/CAs scheduled to be on duty today
 *
 */
- (void)getSchedule
{    
    //if ([self authenticate]) {
        ScheduleConnectionDelegate* d = [[ScheduleConnectionDelegate alloc] init];    
        NSMutableString* url = [[NSMutableString alloc] initWithString:@"http://dev/users/staff/1"];
    
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] 
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", [self.user valueForKey:@"sessid"]] forHTTPHeaderField:@"Cookie"];
        
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
        [connection start];
    //}
}

/**
 * Refresh server data only if authenticated
 *
 */
- (void)refresh
{
    [self getCanAsk];
    [self getQueue];
    [self getSchedule];
    
    /*
    if ([self authenticate]) {
        [self getCanAsk];
        [self getCategories];
        [self getSchedule];
        [self getQueue];
    }*/
}

/**
 * Mark a TF as being here
 *
 */
- (void)setArrival:(TF*)tf
{
    //if ([self authenticate]) {
        // construct URL and POST data
        NSMutableString* url = [[NSMutableString alloc] initWithString:@"http://dev/users/arrival"];
    
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] 
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
        NSString* params = [NSString stringWithFormat:@"id=%d", tf.staffId];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", [self.user valueForKey:@"sessid"]] forHTTPHeaderField:@"Cookie"];
        
        // send request
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:nil];
        [connection start];
    //}
}

/**
 * Get whether or not students can ask questions
 *
 */
- (void)setCanAsk:(BOOL)canAsk
{    
    //if ([self authenticate]) {
        // set up delegate to handle response
        CanAskConnectionDelegate* d = [[CanAskConnectionDelegate alloc] init];
        
        // construct URL based on whether we are enabling or disabling queue
        NSString* url;
        if (canAsk)
            url = @"http://dev/questions/enableQueue/1";
        else
            url = @"http://dev/questions/disableQueue/1";
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", [self.user valueForKey:@"sessid"]] forHTTPHeaderField:@"Cookie"];
        
        // send request
        NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:d];
        [connection start];
    //}
}

@end
