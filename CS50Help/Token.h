//
//  Question.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Token : NSObject
    
@property (strong, nonatomic) NSArray* labels;
@property (strong, nonatomic) NSArray* questionIds;
@property (strong, nonatomic) NSString* student;
@property (assign, nonatomic) int tokenId;

- (id)initWithId:(int)tokenId questionIds:(NSArray*)questionIds withLabels:(NSArray*)labels byStudent:(NSString*)student;

@end
