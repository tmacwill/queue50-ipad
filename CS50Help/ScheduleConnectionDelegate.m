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
        for (NSDictionary* tfInfo in [json valueForKey:@"users"]) {
            TF* tf = [[TF alloc] initWithId:[[[tfInfo valueForKey:@"User"] valueForKey:@"id"] intValue]
                                       name:[[tfInfo valueForKey:@"User"] valueForKey:@"name"]
                                      email:[[tfInfo valueForKey:@"User"] valueForKey:@"email"]
                                   isOnDuty:0];
            [tfs addObject:tf];
        }
            
        // refresh right side
        delegate.halfViewController.detailViewController.allTFs = tfs;
        [delegate.halfViewController.detailViewController.tableView reloadData];
    }
    
    else
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error loading staff" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end