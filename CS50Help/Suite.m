//
//  Suite.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Suite.h"

@implementation Suite

@synthesize name = _name;
@synthesize suiteId = _suiteId;
@synthesize orgId = _orgId;

- (id)initWithName:(NSString *)name suiteId:(int)suiteId orgId:(int)orgId
{
    self = [super init];
    if (self) {
        self.name = name;
        self.suiteId = suiteId;
        self.orgId = orgId;
    }
    
    return self;
}

@end
