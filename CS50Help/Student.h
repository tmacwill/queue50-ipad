//
//  Student.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Student : NSObject {
    
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* question;
@property (nonatomic, retain) NSString* category;

- (id)initWithName:(NSString*)name question:(NSString*)question category:(NSString*)category;

@end
