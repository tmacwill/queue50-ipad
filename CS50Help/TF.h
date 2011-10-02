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

@property (strong, nonatomic) NSString* email;
@property (assign, nonatomic) int isOnDuty;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* phone;
@property (assign, nonatomic) int staffId;

- (id)initWithId:(int)staffId name:(NSString*)name email:(NSString*)email phone:(NSString*)phone isOnDuty:(int)isOnDuty;

@end
