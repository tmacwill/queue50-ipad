//
//  Question.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Token.h"

@implementation Token

@synthesize labels = _labels;
@synthesize questionIds = _questionIds;
@synthesize student = _student;
@synthesize tokenId = _tokenId;

- (id)initWithId:(int)tokenId questionIds:(NSArray*)questionIds withLabels:(NSArray*)labels byStudent:(NSString*)student
{
    self = [super init];
    
    if (self) {
        self.labels = labels;
        self.questionIds = questionIds;
        self.student = student;
        self.tokenId = tokenId;
    }
    
    return self;
}

@end
