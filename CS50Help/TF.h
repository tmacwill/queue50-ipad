//
//  TF.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TF : NSObject {
    
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) int isOnDuty;

- (id)initWithName:(NSString*)name isOnDuty:(int)isOnDuty;

@end
