//
//  ServerController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DetailViewController;
@class FilterViewController;
@class Question;
@class RootViewController;
@class TF;

#define BASE_URL @"http://tommymacwilliam.com/cs50help/"

@interface ServerController : NSObject {

}

@property (strong, nonatomic) DetailViewController* detailViewController;
@property (strong, nonatomic) FilterViewController* filterViewController;
@property (strong, nonatomic) RootViewController* rootViewController;
@property (assign, nonatomic) BOOL hasLoadedQueue;

+ (ServerController*)sharedInstance;
- (void)dispatchQuestionsToTFAtIndexPath:(NSIndexPath*)indexPath;
- (void)getCategories;
- (void)getQueue;
- (void)getSchedule;

@end
