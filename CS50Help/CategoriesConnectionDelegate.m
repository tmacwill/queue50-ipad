//
//  CategoriesConnectionDelegate.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoriesConnectionDelegate.h"
#import "CJSONDeserializer.h"
#import "FilterViewController.h"

@implementation CategoriesConnectionDelegate

@synthesize viewController = _viewController;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* error = nil;
    NSDictionary* categoriesData = [[CJSONDeserializer deserializer] deserializeAsDictionary:self.data
                                                                                 error:&error];
    
    if (!error) {
        // iterate over all TFs/CAs on the schedule for tonight
        NSMutableArray* categories = [[NSMutableArray alloc] init];
        [categories addObject:@"All"];
        for (NSDictionary* category in [categoriesData valueForKey:@"categories"]) {
            [categories addObject:[category valueForKey:@"category"]];
        }
        
        self.viewController.categories = [categories mutableCopy];
        [self.viewController.tableView reloadData];
    }
}

@end
