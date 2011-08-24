//
//  QueueConnectionDelegate.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDelegate.h"

@class Course;
@class RootViewController;

@interface QueueConnectionDelegate : ConnectionDelegate

@property (strong, nonatomic) RootViewController* viewController;
@property (strong, nonatomic) Course* course;

+ (QueueConnectionDelegate*)sharedInstance;

@end
