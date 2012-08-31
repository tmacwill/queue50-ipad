//
//  TokenLabel.m
//  CS50 Queue
//
//  Created by Tommy MacWilliam on 8/30/12.
//
//

#import "TokenLabel.h"

@implementation TokenLabel

@synthesize color = _color;
@synthesize label = _label;

- (id)initWithLabel:(NSString*)label color:(int)color
{
    self = [super init];
    if (self) {
        self.label = label;
        self.color = color;
    }
    
    return self;
}

@end
