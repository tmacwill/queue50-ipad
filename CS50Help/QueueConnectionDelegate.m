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
#import "TokenLabel.h"

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
        for (NSDictionary* post in [json valueForKey:@"tokens"]) {
            NSMutableArray* postIds = [[NSMutableArray alloc] init];
            NSMutableArray* labels = [[NSMutableArray alloc] init];
            
            // iterate over each post associated with the token
            for (NSDictionary* postToken in [post valueForKey:@"PostTokens"]) {
                [postIds addObject:[NSNumber numberWithInt:[[[postToken valueForKey:@"Post"] valueForKey:@"id"] intValue]]];
                
                // display only the most specific label for this post
                if ([[[postToken valueForKey:@"Post"] valueForKey:@"Labels"] count]) {
                    // determine text and color of label
                    NSString* label = [[[[postToken valueForKey:@"Post"] valueForKey:@"Labels"] lastObject] valueForKey:@"name"];
                    int color = [[[[[postToken valueForKey:@"Post"] valueForKey:@"Labels"] lastObject] valueForKey:@"color"] intValue];
                    
                    TokenLabel* tokenLabel = [[TokenLabel alloc] initWithLabel:label color:color];
                    [labels addObject:tokenLabel];
                }
            }
                 
            // create token containing question and labels
            Token* token = [[Token alloc] initWithId:[[[post valueForKey:@"Token"] valueForKey:@"id"] intValue]
                                         questionIds:postIds
                                          withLabels:labels
                                           byStudent:[[post valueForKey:@"User"] valueForKey:@"name"]];
                        
            // add row to left side
            [delegate.halfViewController.rootViewController.tokens addObject:token];
        }
    }
    
    // refresh left side
    delegate.halfViewController.rootViewController.activityIndicator.hidden = YES;
    [delegate.halfViewController.rootViewController refreshTable];
}

@end
