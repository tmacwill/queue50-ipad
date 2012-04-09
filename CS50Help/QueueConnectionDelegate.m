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
#import "QueueConnectionDelegate.h"
#import "Token.h"

@implementation QueueConnectionDelegate


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    CS50HelpAppDelegate* delegate = [UIApplication sharedApplication].delegate;
    NSError* error = nil;
    NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error];
    
    if (!error) {
        // clear all previous questions
        [delegate.halfViewController.rootViewController.tokens removeAllObjects];
        
        // iterate over all tokens in the queue
        for (NSDictionary* q in [json valueForKey:@"tokens"]) {
            // get each question associated with the current token
            NSMutableArray* questionIds = [[NSMutableArray alloc] init];
            for (NSDictionary* questionToken in [q valueForKey:@"QuestionTokens"])
                [questionIds addObject:[NSNumber numberWithInt:[[[questionToken valueForKey:@"Question"] valueForKey:@"id"] intValue]]];
            
            // extract label from each question associated with the current token
            NSMutableArray* labels = [[NSMutableArray alloc] init];
            for (NSDictionary* questionToken in [q valueForKey:@"QuestionTokens"])
                [labels addObject:[[[[questionToken valueForKey:@"Question"] valueForKey:@"Labels"] firstObject] valueForKey:@"name"]];
                 
            // create token containing question and labels
            Token* token = [[Token alloc] initWithId:[[[q valueForKey:@"Token"] valueForKey:@"id"] intValue]
                                         questionIds:questionIds
                                          withLabels:labels
                                           byStudent:[[q valueForKey:@"User"] valueForKey:@"name"]];
                        
            // add row to left side
            [delegate.halfViewController.rootViewController.tokens addObject:token];
        }
    }
    
    // refresh left side
    delegate.halfViewController.rootViewController.activityIndicator.hidden = YES;
    [delegate.halfViewController.rootViewController refreshTable];
}

@end
