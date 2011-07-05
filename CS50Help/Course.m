//
//  Course.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Course.h"

@implementation Course

@synthesize name = _name;
@synthesize url = _url;

- (id)initWithName:(NSString *)name url:(NSString *)url
{
    self = [super init];
    if (self) {
        self.name = name;
        self.url = url;
    }
    
    return self;
}

@end
