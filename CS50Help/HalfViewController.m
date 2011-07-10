//
//  HalfViewController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HalfViewController.h"
#import "RootViewController.h"

@implementation HalfViewController

@synthesize detailViewController = _detailViewController;
@synthesize filterViewController = _filterViewController;
@synthesize rootViewController = _rootViewController;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
