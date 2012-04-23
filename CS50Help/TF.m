//
//  TF.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TF.h"

@implementation TF

@synthesize email = _email;
@synthesize isOnDuty = _isOnDuty;
@synthesize lastDispatchTime = _lastDispatchTime;
@synthesize lastNotifyTime = _lastNotifyTime;
@synthesize name = _name;
@synthesize staffId = _staffId;
@synthesize state = _state;
@synthesize tokens = _tokens;

- (id)initWithId:(int)staffId name:(NSString*)name email:(NSString*)email isOnDuty:(int)isOnDuty;
{
    self = [super init];
    
    if (self != nil) {
        self.name = name;
        self.isOnDuty = isOnDuty;
        self.email = email;
        self.staffId = staffId;
        
        self.lastDispatchTime = nil;
        self.lastNotifyTime = nil;
        self.state = kStateAvailable;
        self.tokens = nil;
    }
    
    return self;
}


@end
