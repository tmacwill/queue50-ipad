//
//  Dispatch.m
//  CS50 Queue
//
//  Created by Tommy MacWilliam on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Dispatch.h"
#import "TF.h"

@implementation Dispatch

@synthesize tokens = _tokens;
@synthesize tf = _tf;
@synthesize time = _time;

- (id)initWithTokens:(NSArray*)tokens toTF:(TF*)tf atTime:(NSDate*)time
{
    self = [super init];
    
    if (self) {
        self.tokens = tokens;
        self.tf = tf;
        self.time = time;
    }
    
    return self;
}

@end
