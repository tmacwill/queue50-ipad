//
//  ScheduleConnectionDelegate.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CS50HelpAppDelegate.h"
#import "DetailViewController.h"
#import "HalfViewController.h"
#import "ScheduleConnectionDelegate.h"
#import "TF.h"

@implementation ScheduleConnectionDelegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    CS50HelpAppDelegate* delegate = [UIApplication sharedApplication].delegate;
    NSError* error = nil;
    NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error];
    
    if (!error) {
        // iterate over all TFs/CAs on the schedule for tonight
        NSMutableArray* tfs = [[NSMutableArray alloc] init];
        for (NSDictionary* tfInfo in [json valueForKey:@"staff"]) {
            TF* tf = [[TF alloc] initWithId:[[tfInfo valueForKey:@"id"] intValue] 
                                       name:[tfInfo valueForKey:@"name"] 
                                      email:@""
                                   isOnDuty:0];
            [tfs addObject:tf];
        }
    
        // refresh right side
        delegate.halfViewController.detailViewController.allTFs = tfs;
        [delegate.halfViewController.detailViewController.tableView reloadData];
    }
}

@end