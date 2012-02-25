//
//  Question.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Question.h"

@implementation Question

@synthesize label = _label;
@synthesize name = _name;
@synthesize question = _question;
@synthesize questionId = _questionId;

- (id)initWithId:(int)questionId 
        question:(NSString*)question
     studentName:(NSString*)name
           label:(NSString *)label
{
    self = [super init];
    
    if (self != nil) {
        self.questionId = questionId;
        self.name = name;
        self.question = question;
        self.label = label;
    }
    
    return self;
}


@end
