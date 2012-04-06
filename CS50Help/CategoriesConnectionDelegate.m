//
//  CategoriesConnectionDelegate.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoriesConnectionDelegate.h"
#import "CS50HelpAppDelegate.h"
#import "HalfViewController.h"
#import "RootViewController.h"

@implementation CategoriesConnectionDelegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    CS50HelpAppDelegate* delegate = [UIApplication sharedApplication].delegate;
    NSError* error = nil;
    NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error];
    
    if (!error) {
        // add each label to the root view controller list
        for (NSDictionary* label in [json valueForKey:@"labels"])
            [delegate.halfViewController.rootViewController.labels addObject:[[label valueForKey:@"Label"] valueForKey:@"name"]];
    }
}

@end
