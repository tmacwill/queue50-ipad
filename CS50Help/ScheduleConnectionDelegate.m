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
    for (NSString* tfName in [schedule valueForKey:@"schedule"]) {
        // @TODO: spreadsheets/schedule should include all TFs, not just those on duty
        TF* tf = [[TF alloc] initWithName:tfName isOnDuty:YES];
        [tfs addObject:tf];
    }
    
    // @TODO: schedule will return a list of all TFs, with another property specifying if they are on duty
    self.viewController.allTFs = tfs;
    [self.viewController buildOnDutyTFs];
}

@end
