//
//  ServerController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthViewController.h"

@class Course;
@class CourseSelectionViewController;
@class HalfViewController;
@class Question;
@class TF;

//#define DEBUG_URL 1

#ifdef DEBUG_URL
    #define BASE_URL @"http://192.168.56.50/"
#endif

#ifndef DEBUG_URL
    #define BASE_URL @"http://queue.cs50.net/"
#endif

@interface ServerController : NSObject <AuthViewControllerDelegate>

@property (strong, nonatomic) Course* course;
@property (strong, nonatomic) CourseSelectionViewController* courseSelectionViewController;
@property (strong, nonatomic) HalfViewController* halfViewController;
@property (assign, nonatomic) BOOL hasLoadedQueue;
@property (assign, nonatomic) BOOL isFormPresent;
@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) NSMutableString* url;
@property (strong, nonatomic) NSDictionary* user;

+ (ServerController*)sharedInstance;
- (BOOL)authenticate;
- (void)dispatchTokens:(NSArray*)tokens toTF:(TF*)tf;
- (void)getCanAsk;
- (void)getCourses;
- (void)getLabels;
- (void)getQueue;
- (void)getSchedule;
- (void)refresh;
- (void)setArrival:(TF*)tf;
- (void)setCanAsk:(BOOL)canAsk;

@end
