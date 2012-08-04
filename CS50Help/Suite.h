//
//  Suite.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Suite : NSObject

@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) int orgId;
@property (assign, nonatomic) int suiteId;

- (id)initWithName:(NSString*)name suiteId:(int)suiteId orgId:(int)orgId;

@end
