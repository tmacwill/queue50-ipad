//
//  QueueConnectionDelegate.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RootViewController;

@interface QueueConnectionDelegate : NSObject

@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) RootViewController* viewController;

@end
