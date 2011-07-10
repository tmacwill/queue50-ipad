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

#define BASE_URL @"http://tommymacwilliam.com/cs50help/"

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
- (void)dispatchQuestionsToTFAtIndexPath:(NSIndexPath*)indexPath;
- (void)getCategories;
- (void)getCourses;
- (void)getQueue;
- (void)getSchedule;
- (void)refresh;

@end
