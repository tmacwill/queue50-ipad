//
//  CanAskConnectionDelegate.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 10/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDelegate.h"

@class RootViewController;

@interface CanAskConnectionDelegate : ConnectionDelegate

@property (strong, nonatomic) RootViewController* viewController;

@end