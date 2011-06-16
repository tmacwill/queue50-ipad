//
//  QueueConnectionDelegate.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CJSONDeserializer.h"
#import "RootViewController.h"
#import "Question.h"
#import "QueueConnectionDelegate.h"

@implementation QueueConnectionDelegate

@synthesize viewController=_viewController;

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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* error;
    NSDictionary* queue = [[CJSONDeserializer deserializer] deserializeAsDictionary:self.data
                                                                                 error:&error];
    
    [self.viewController.questions removeAllObjects];
    for (NSDictionary* q in [queue valueForKey:@"queue"]) {
        Question* question = [[Question alloc] initWithId:[[q valueForKey:@"id"] intValue]
                                                 question:[q valueForKey:@"question"]
                                              studentName:[q valueForKey:@"name"]
                                                 category:[q valueForKey:@"category"]];
        
        [self.viewController.questions addObject:question];
    }
    
    [self.viewController.tableView reloadData];
}

@end
