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
#import "TF.h"

@implementation DispatchConnectionDelegate

@synthesize detailViewController = _detailViewController;
@synthesize rootViewController = _rootViewController;
@synthesize tf = _tf;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // deselect all questions, since we just dispatched
    [self.rootViewController.selectedQuestions removeAllObjects];
    
    // place TF at bottom of list
    [self.detailViewController.onDutyTFs removeObject:self.tf];
    [self.detailViewController.onDutyTFs addObject:self.tf];
}


@end
