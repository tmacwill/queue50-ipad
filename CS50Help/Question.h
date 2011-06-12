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

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* question;
@property (nonatomic, retain) NSString* category;

- (id)initWithQuestion:(NSString*)question studentName:(NSString*)name category:(NSString*)category;


@end
