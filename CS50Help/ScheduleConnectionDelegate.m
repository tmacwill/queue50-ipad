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
