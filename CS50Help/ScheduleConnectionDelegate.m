//
//  ScheduleConnectionDelegate.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CJSONDeserializer.h"
#import "DetailViewController.h"
#import "RootViewController.h"
#import "ScheduleConnectionDelegate.h"
#import "TF.h"

@implementation ScheduleConnectionDelegate

@synthesize viewController = _viewController;

- (id)init 
{
    self = [super init];
    return self;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* error = nil;
    NSDictionary* schedule = [[CJSONDeserializer deserializer] deserializeAsDictionary:self.data
                                                                                 error:&error];
    
    if (!error) {
        // iterate over all TFs/CAs on the schedule for tonight
        NSMutableArray* tfs = [[NSMutableArray alloc] init];
        for (NSDictionary* tfInfo in [schedule valueForKey:@"schedule"]) {
            TF* tf = [[TF alloc] initWithId:[[tfInfo valueForKey:@"id"] intValue] 
                                       name:[tfInfo valueForKey:@"name"] 
                                      email:[tfInfo valueForKey:@"email"]
                                      phone:[tfInfo valueForKey:@"phone"]
                                   isOnDuty:[[tfInfo valueForKey:@"on_duty"] intValue]];
            [tfs addObject:tf];
        }
    
        self.viewController.allTFs = tfs;
        [self.viewController.tableView reloadData];
    }
}

@end
