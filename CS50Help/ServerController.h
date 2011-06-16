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

@property (strong, nonatomic) RootViewController* rootViewController;
@property (strong, nonatomic) DetailViewController* detailViewController;

+ (ServerController*)sharedInstance;
- (void)dispatchQuestionsToTFAtIndexPath:(NSIndexPath*)indexPath;
- (void)getQueue;
- (void)getSchedule;

@end
