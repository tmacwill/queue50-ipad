//
//  Question.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Question.h"

@implementation Question

@synthesize category=_category;
@synthesize name=_name;
@synthesize position=_position;
@synthesize question=_question;
@synthesize questionId=_questionId;

- (id)initWithId:(int)questionId question:(NSString*)question position:(int)position
     studentName:(NSString*)name category:(NSString*)category
{
    self = [super init];
    
    if (self != nil) {
        self.questionId = questionId;
        self.position = position;
        self.name = name;
        self.question = question;
        self.category = category;
    }
    
    return self;
}


@end
