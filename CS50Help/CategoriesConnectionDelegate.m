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

@synthesize viewController=_viewController;

static CategoriesConnectionDelegate* instance;

/**
 * Class is a singleton, get the only instance
 *
 */
+ (CategoriesConnectionDelegate*)sharedInstance
{
    @synchronized(self) {
        if (!instance) {
            instance = [[CategoriesConnectionDelegate alloc] init];
            instance.data = [[NSMutableData alloc] init];
        }
    }
    
    return instance;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* error;
    NSDictionary* categoriesData = [[CJSONDeserializer deserializer] deserializeAsDictionary:self.data
                                                                                 error:&error];
    
    // iterate over all TFs/CAs on the schedule for tonight
    NSMutableArray* categories = [[NSMutableArray alloc] init];
    for (NSString* category in [categoriesData valueForKey:@"categories"]) {
        [categories addObject:category];
    }
    
    self.viewController.categories = [categories mutableCopy];
    self.viewController.selectedCategories = [categories mutableCopy];
    
    [self.viewController.tableView reloadData];
}


@end
