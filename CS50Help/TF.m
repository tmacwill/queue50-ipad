//
//  TF.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TF.h"

@implementation TF

@synthesize isOnDuty=_isOnDuty;
@synthesize name=_name;

- (id)initWithName:(NSString *)name isOnDuty:(int)isOnDuty
{
    self = [super init];
    
    if (self != nil) {
        self.name = name;
        self.isOnDuty = isOnDuty;
    }
    
    return self;
}


@end
