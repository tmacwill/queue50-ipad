//
//  ScheduleConnectionDelegate.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DetailViewController;

@interface ScheduleConnectionDelegate : NSObject

@property (nonatomic, retain) NSMutableData* data;
@property (nonatomic, retain) DetailViewController* viewController;

@end
