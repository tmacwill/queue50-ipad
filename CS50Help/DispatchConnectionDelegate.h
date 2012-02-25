//
//  DispatchConnectionDelegate.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDelegate.h"

@class TF;

@interface DispatchConnectionDelegate : ConnectionDelegate

@property (strong, nonatomic) TF* tf;

@end
