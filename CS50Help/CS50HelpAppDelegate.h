//
//  CS50HelpAppDelegate.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HalfViewController;

@interface CS50HelpAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) HalfViewController* halfViewController;
@property (strong, nonatomic) UIWindow* window;

@end
