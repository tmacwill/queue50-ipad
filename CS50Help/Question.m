//
//  Question.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Question.h"

@implementation Question

@synthesize name=_name, question=_question, category=_category;

- (id)initWithQuestion:(NSString*)question studentName:(NSString*)name category:(NSString*)category
{
    self = [super init];
    
    if (self != nil) {
        self.name = name;
        self.question = question;
        self.category = category;
    }
    
    return self;
}


@end
