//
//  ServerController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthViewController.h"
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
- (void)dispatchQuestionsToTFAtIndexPath:(NSIndexPath*)indexPath;
{    
    if ([self authenticate]) {
        // set up connection delegate
        TF* tf = [self.halfViewController.detailViewController.onDutyTFs objectAtIndex:indexPath.row];
        DispatchConnectionDelegate* d = [[DispatchConnectionDelegate alloc] init];
        d.rootViewController = self.halfViewController.rootViewController;
        d.detailViewController = self.halfViewController.detailViewController;
        d.tfIndexPath = indexPath;
        d.questionIndexPaths = self.halfViewController.rootViewController.selectedRows;
    
        // create comma separated list of question ids
        NSMutableString* questionsParam = [[NSMutableString alloc] initWithString:@"ids="];
        for (NSIndexPath* questionIndexPath in self.halfViewController.rootViewController.selectedRows) {
            Question* q = [self.halfViewController.rootViewController.questions objectAtIndex:questionIndexPath.row];
            [questionsParam appendFormat:@"%d,", q.questionId];
        }
    
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:[self.url stringByAppendingFormat:
                                                              @"api/v1/questions/dispatch"]]];
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
        d.viewController = self.halfViewController.filterViewController;
    
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:
                                         [self.url stringByAppendingFormat:@"api/v1/spreadsheets/categories"]]];
        [request addValue:[NSString stringWithFormat:@"PHPSESSID=%@", [self.user valueForKey:@"sessid"]]
                                  forHTTPHeaderField:@"Cookie"];
        
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
    
    NSLog(@"%@", request.URL);
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
        QueueConnectionDelegate* d = [QueueConnectionDelegate sharedInstance];
        d.viewController = self.halfViewController.rootViewController;
        NSMutableString* url = [[NSMutableString alloc] initWithString:
                                [self.url stringByAppendingString:@"api/v1/questions/queue"]];
    
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
        d.viewController = self.halfViewController.detailViewController;
    
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:
                                         [self.url stringByAppendingFormat:@"api/v1/spreadsheets/schedule"]]];
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
