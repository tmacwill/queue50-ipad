//
//  QueueConnectionDelegate.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDelegate.h"

@interface QueueConnectionDelegate : ConnectionDelegate

+ (QueueConnectionDelegate*)sharedInstance;

@end
