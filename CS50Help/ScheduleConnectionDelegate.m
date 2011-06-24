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

@synthesize viewController=_viewController;

static ScheduleConnectionDelegate* instance;

/**
 * Class is a singleton, get the only instance
 *
 */
+ (ConnectionDelegate*)sharedInstance
{
    @synchronized(self) {
        if (!instance) {
            instance = [[ScheduleConnectionDelegate alloc] init];
            instance.data = [[NSMutableData alloc] init];
        }
    }
    
    return instance;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* error;
    NSDictionary* schedule = [[CJSONDeserializer deserializer] deserializeAsDictionary:self.data
                                                                                 error:&error];
    
    // iterate over all TFs/CAs on the schedule for tonight
    NSMutableArray* tfs = [[NSMutableArray alloc] init];
    for (NSDictionary* tfInfo in [schedule valueForKey:@"schedule"]) {
        TF* tf = [[TF alloc] initWithName:[tfInfo valueForKey:@"name"]
                                    email:[tfInfo valueForKey:@"email"]
                                    phone:[tfInfo valueForKey:@"phone"]
                                 isOnDuty:[[tfInfo valueForKey:@"on_duty"] intValue]];
        [tfs addObject:tf];
    }
    
    self.viewController.allTFs = tfs;
    [self.viewController.tableView reloadData];
}

@end
