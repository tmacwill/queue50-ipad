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
    NSError* error;
    NSDictionary* courseData = [[CJSONDeserializer deserializer] deserializeAsDictionary:self.data 
                                                                                   error:&error];
    
    // iterate over all registered courses
    NSMutableArray* courses = [[NSMutableArray alloc] init];
    for (NSDictionary* course in [courseData valueForKey:@"courses"]) {
        Course* c = [[Course alloc] initWithName:[course valueForKey:@"name"] 
                                             url:[course valueForKey:@"url"]];
        [courses addObject:c];
    }
    
    self.viewController.courses = [courses mutableCopy];
    [self.viewController.tableView reloadData];
}


@end
