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

#define BASE_URL @"http://beta.help.cs76.net/"

@interface ServerController : NSObject <AuthViewControllerDelegate>

@property (strong, nonatomic) Course* course;
@property (strong, nonatomic) CourseSelectionViewController* courseSelectionViewController;
@property (strong, nonatomic) HalfViewController* halfViewController;
@property (assign, nonatomic) BOOL isFormPresent;
@property (strong, nonatomic) UINavigationController* navController;
@property (assign, nonatomic) int suiteId;
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
- (NSURL*)urlForAction:(NSString *)action includeSuite:(BOOL)includeSuite;

@end
