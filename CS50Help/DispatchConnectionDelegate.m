//
//  DispatchConnectionDelegate.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "DispatchConnectionDelegate.h"
#import "RootViewController.h"

@implementation DispatchConnectionDelegate

@synthesize detailViewController = _detailViewController;
@synthesize rootViewController = _rootViewController;
@synthesize tfIndexPath = _tfIndexPath;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.rootViewController.selectedQuestions removeAllObjects];
    [self.detailViewController.tableView deselectRowAtIndexPath:self.tfIndexPath animated:YES];
}


@end
