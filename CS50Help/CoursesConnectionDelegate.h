//
//  CoursesConnectionDelegate.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDelegate.h"

@class CourseSelectionViewController;

@interface CoursesConnectionDelegate : ConnectionDelegate

@property (strong, nonatomic) CourseSelectionViewController* viewController;

@end
