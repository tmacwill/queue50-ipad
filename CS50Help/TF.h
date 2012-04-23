//
//  TF.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kStateAvailable,
    kStateUnavailable,
    kStateNotified,
    kStateSnoozed
} TFState;

@interface TF : NSObject

@property (strong, nonatomic) NSString* email;
@property (assign, nonatomic) int isOnDuty;
@property (strong, nonatomic) NSDate* lastDispatchTime;
@property (strong, nonatomic) NSDate* lastNotifyTime;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) int staffId;
@property (strong, nonatomic) NSArray* tokens;
@property (assign, nonatomic) TFState state;

- (id)initWithId:(int)staffId name:(NSString*)name email:(NSString*)email isOnDuty:(int)isOnDuty;

@end
