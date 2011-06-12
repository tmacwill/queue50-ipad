//
//  ServerController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DetailViewController;
@class Question;
@class RootViewController;
@class TF;

#define BASE_URL @"http://tommymacwilliam.com/cs50help/"

@interface ServerController : NSObject {

}

+ (ServerController*)sharedInstance;
- (void)dispatchStudent:(Question*)student toTF:(TF*)tf;
- (void)getQueueForViewController:(RootViewController*)viewController;
- (void)getScheduleForViewController:(DetailViewController*)viewController;

@end
