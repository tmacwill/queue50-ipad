//
//  Course.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* url;

- (id)initWithName:(NSString*)name url:(NSString*)url;

@end
