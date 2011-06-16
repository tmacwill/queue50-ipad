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

@property (assign, nonatomic) int questionId;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* question;
@property (strong, nonatomic) NSString* category;

- (id)initWithId:(int)questionId question:(NSString*)question studentName:(NSString*)name category:(NSString*)category;


@end
