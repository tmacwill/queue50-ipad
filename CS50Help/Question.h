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

@property (strong, nonatomic) NSString* category;
@property (assign, nonatomic) int categoryColor;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) int position;
@property (assign, nonatomic) int questionId;
@property (strong, nonatomic) NSString* question;


- (id)initWithId:(int)questionId question:(NSString*)question position:(int)position 
     studentName:(NSString*)name category:(NSString*)category categoryColor:(int)categoryColor;

@end
