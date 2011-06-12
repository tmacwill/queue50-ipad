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

@synthesize data=_data, viewController=_viewController;

- (id)init
{
    self = [super init];
    if (self) {
        self.data = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{  
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* error;
    NSDictionary* queue = [[CJSONDeserializer deserializer] deserializeAsDictionary:self.data
                                                                                 error:&error];
    
    [self.viewController.questions removeAllObjects];
    for (NSDictionary* q in [queue valueForKey:@"queue"]) {
        Question* question = [[Question alloc] initWithQuestion:[q valueForKey:@"question"]
                                                    studentName:[q valueForKey:@"name"]
                                                       category:[q valueForKey:@"category"]];
        
        [self.viewController.questions addObject:question];
    }
    
    [self.viewController.tableView reloadData];
}

@end
