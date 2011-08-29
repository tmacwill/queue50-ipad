//
//  DispatchConnectionDelegate.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDelegate.h"

@class DetailViewController;
@class RootViewController;

@interface DispatchConnectionDelegate : ConnectionDelegate

@property (strong, nonatomic) DetailViewController* detailViewController;
@property (strong, nonatomic) RootViewController* rootViewController;
@property (strong, nonatomic) NSIndexPath* tfIndexPath;

@end
