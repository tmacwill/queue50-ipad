//
//  Question.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject {
    
}

@property (strong, nonatomic) NSString* label;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) int questionId;
@property (strong, nonatomic) NSString* question;


- (id)initWithId:(int)questionId 
        question:(NSString*)question 
     studentName:(NSString*)name 
           label:(NSString*)label;

@end
