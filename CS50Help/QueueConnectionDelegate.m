//
//  QueueConnectionDelegate.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CS50HelpAppDelegate.h"
#import "HalfViewController.h"
#import "RootViewController.h"
#import "Question.h"
#import "QueueConnectionDelegate.h"

@implementation QueueConnectionDelegate

static QueueConnectionDelegate* instance;

/**
 * Class is a singleton, get the only instance
 *
 */
+ (QueueConnectionDelegate*)sharedInstance
{
    @synchronized(self) {
        if (!instance) {
            instance = [[QueueConnectionDelegate alloc] init];
            instance.data = [[NSMutableData alloc] init];
        }
    }
    
    return instance;
}

- (id)init 
{
    self = [super init];
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    CS50HelpAppDelegate* delegate = [UIApplication sharedApplication].delegate;
    NSError* error = nil;
    NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error];
    
    // only reload queue on success and change
    if (!error) {
        [delegate.halfViewController.rootViewController.questions removeAllObjects];
        for (NSDictionary* q in [json valueForKey:@"questions"]) {
            
            Question* question = [[Question alloc] initWithId:[[q valueForKey:@"id"] intValue]
                                                     question:[q valueForKey:@"question"]
                                                  studentName:[[q valueForKey:@"student"] valueForKey:@"name"]
                                                        label:[[[q valueForKey:@"labels"] firstObject] valueForKey:@"name"]];
            
            [delegate.halfViewController.rootViewController.questions addObject:question];
        }
    }
    
    [delegate.halfViewController.rootViewController buildVisibleQuestions];
}

@end
