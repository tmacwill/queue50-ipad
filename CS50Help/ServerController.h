//
//  ServerController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Student;
@class TF;

#define BASE_URL @"http://tommymacwilliam.com/cs50help/"

@protocol ServerControllerDelecate <NSObject>
- (void)didReceiveQueue;
@end

@interface ServerController : NSObject {

}

- (void)dispatchStudent:(Student*)student toTF:(TF*)tf;
- (void)getQueue;

@end
