//
//  TokenLabel.h
//  CS50 Queue
//
//  Created by Tommy MacWilliam on 8/30/12.
//
//

#import <Foundation/Foundation.h>

@interface TokenLabel : NSObject

@property (assign, nonatomic) int color;
@property (strong, nonatomic) NSString* label;

- (id)initWithLabel:(NSString*)label color:(int)color;

@end
