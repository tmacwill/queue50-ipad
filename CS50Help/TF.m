//
//  TF.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TF.h"

@implementation TF

@synthesize email=_email;
@synthesize isOnDuty=_isOnDuty;
@synthesize name=_name;
@synthesize phone=_phone;

- (id)initWithName:(NSString*)name email:(NSString*)email phone:(NSString*)phone isOnDuty:(int)isOnDuty;
{
    self = [super init];
    
    if (self != nil) {
        self.name = name;
        self.isOnDuty = isOnDuty;
        self.email = email;
        self.phone = phone;
    }
    
    return self;
}


@end
