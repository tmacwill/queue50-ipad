//
//  Student.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Student.h"


@implementation Student

@synthesize name=_name, question=_question, category=_category;

- (id)initWithName:(NSString*)name question:(NSString*)question category:(NSString*)category
{
    self = [super init];
    
    if (self != nil) {
        self.name = name;
        self.question = question;
        self.category = category;
    }
    
    return self;
}

- (void)dealloc
{
    [_name release];
    [_question release];
    [_category release];
    
    [super dealloc];
}

@end
