//
//  SuitesConnectionDelegate.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Suite.h"
#import "SuitesConnectionDelegate.h"
#import "SuiteSelectionViewController.h"

@implementation SuitesConnectionDelegate

@synthesize viewController = _viewController;

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSError* error = nil;
    NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error];
    
    if (!error) {
        // iterate over all registered courses
        NSMutableArray* suites = [[NSMutableArray alloc] init];
        for (NSDictionary* suite in [json valueForKey:@"suites"]) {
            NSDictionary* suiteInfo = [suite valueForKey:@"Suite"];
            Suite* s = [[Suite alloc] initWithName:[suiteInfo valueForKey:@"name"]
                                           suiteId:[[suiteInfo valueForKey:@"id"] intValue]
                                             orgId:[[suiteInfo valueForKey:@"org_id"] intValue]];
            [suites addObject:s];
        }
                
        self.viewController.suites = [suites mutableCopy];
        [self.viewController.tableView reloadData];
    }
}


@end
