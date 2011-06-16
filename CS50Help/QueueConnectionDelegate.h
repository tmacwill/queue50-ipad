//
//  QueueConnectionDelegate.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDelegate.h"

@class RootViewController;

@interface QueueConnectionDelegate : ConnectionDelegate

@property (strong, nonatomic) RootViewController* viewController;

+ (QueueConnectionDelegate*)sharedInstance;

@end
