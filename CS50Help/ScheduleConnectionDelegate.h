//
//  ScheduleConnectionDelegate.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDelegate.h"

@class DetailViewController;

@interface ScheduleConnectionDelegate : ConnectionDelegate

@property (strong, nonatomic) DetailViewController* viewController;

@end
