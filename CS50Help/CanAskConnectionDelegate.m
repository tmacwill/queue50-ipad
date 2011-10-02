//
//  CanAskConnectionDelegate.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 10/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CanAskConnectionDelegate.h"
#import "CategoriesConnectionDelegate.h"
#import "CJSONDeserializer.h"
#import "RootViewController.h"

@implementation CanAskConnectionDelegate

@synthesize viewController = _viewController;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError* error = nil;
    NSDictionary* canAskData = [[CJSONDeserializer deserializer] deserializeAsDictionary:self.data
                                                                                   error:&error];
    
    if (!error) {
        BOOL canAsk = [[canAskData valueForKey:@"can_ask"] boolValue];
        self.viewController.canAsk = canAsk;
        
        UINavigationItem* item = (UINavigationItem*)[self.viewController.toolbar.items objectAtIndex:0];
        
        // update UI to reflect state on server
        if (canAsk) {
            item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause
                                                                                    target:self.viewController
                                                                                    action:@selector(toggleQueue:)];
        }
        else {
            item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                                    target:self.viewController
                                                                                    action:@selector(toggleQueue:)];
        }
    }
}


@end
