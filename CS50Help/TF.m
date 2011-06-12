//
//  TF.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TF.h"


@implementation TF

@synthesize name=_name, isOnDuty=_isOnDuty;

- (id)initWithName:(NSString *)name isOnDuty:(BOOL)isOnDuty
{
    self = [super init];
    
    if (self != nil) {
        self.name = name;
        self.isOnDuty = isOnDuty;
    }
    
    return self;
}


@end
