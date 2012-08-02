//
//  CoursesConnectionDelegate.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Course.h"
#import "CoursesConnectionDelegate.h"
#import "CourseSelectionViewController.h"
#import "CJSONDeserializer.h"

@implementation CoursesConnectionDelegate

@synthesize viewController = _viewController;

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSError* error = nil;
    NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error];
    
    if (!error) {
        // iterate over all registered courses
        NSMutableArray* courses = [[NSMutableArray alloc] init];
        for (NSDictionary* course in [json valueForKey:@"suites"]) {
            NSDictionary* s = [course valueForKey:@"Suite"];
            Course* c = [[Course alloc] initWithName:[s valueForKey:@"name"]
                                             suiteId:[[s valueForKey:@"id"] intValue]
                                               orgId:[[s valueForKey:@"org_id"] intValue]];
            [courses addObject:c];
        }
                
        self.viewController.courses = [courses mutableCopy];
        [self.viewController.tableView reloadData];
    }
}


@end
