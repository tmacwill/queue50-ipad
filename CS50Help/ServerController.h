//
//  ServerController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuthViewController.h"

@class Suite;
@class SuiteSelectionViewController;
@class HalfViewController;
@class Question;
@class TF;

#define BASE_URL @"https://apps.cs50.net/"

@interface ServerController : NSObject <AuthViewControllerDelegate>

@property (strong, nonatomic) SuiteSelectionViewController* suiteSelectionViewController;
@property (strong, nonatomic) HalfViewController* halfViewController;
@property (assign, nonatomic) BOOL isFormPresent;
@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) NSString* sessid;
@property (assign, nonatomic) int suiteId;

+ (ServerController*)sharedInstance;
- (BOOL)authenticate;
- (void)dispatchTokens:(NSArray*)tokens toTF:(TF*)tf;
- (void)getCanAsk;
- (void)getSuites;
- (void)getLabels;
- (void)getQueue;
- (void)getSchedule;
- (void)notifyTF:(TF*)tf;
- (void)refresh;
- (void)setArrival:(TF*)tf;
- (void)setCanAsk:(BOOL)canAsk;

@end
