//
//  CanAskConnectionDelegate.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 10/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CanAskConnectionDelegate.h"
#import "CategoriesConnectionDelegate.h"
#import "CS50HelpAppDelegate.h"
#import "HalfViewController.h"
#import "RootViewController.h"

@implementation CanAskConnectionDelegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    CS50HelpAppDelegate* delegate = [UIApplication sharedApplication].delegate;
    NSError* error = nil;
    NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error];
    
    if (!error) {
        // save state value in left side
        BOOL canAsk = [[json valueForKey:@"state"] intValue];
        delegate.halfViewController.rootViewController.canAsk = canAsk;
        
        // get the queue enable/disable button
        UINavigationItem* item = (UINavigationItem*)[delegate.halfViewController.rootViewController.toolbar.items objectAtIndex:0];
        
        // update button to reflect state on server
        if (canAsk) {
            item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause
                                                                                    target:delegate.halfViewController.rootViewController
                                                                                    action:@selector(toggleQueue:)];
        }
        else {
            item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                                    target:delegate.halfViewController.rootViewController
                                                                                    action:@selector(toggleQueue:)];
        }
    }
}


@end
