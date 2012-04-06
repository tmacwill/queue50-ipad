//
//  Dispatch.h
//  CS50 Queue
//
//  Created by Tommy MacWilliam on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TF;

@interface Dispatch : NSObject

@property (strong, nonatomic) NSArray* tokens;
@property (strong, nonatomic) TF* tf;
@property (strong, nonatomic) NSDate* time;

- (id)initWithTokens:(NSArray*)tokens toTF:(TF*)tf atTime:(NSDate*)time;

@end
