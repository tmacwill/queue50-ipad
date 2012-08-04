//
//  QuestionThreadViewController.m
//  CS50 Queue
//
//  Created by Tommy MacWilliam on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThreadViewController.h"
#import "ServerController.h"

@implementation ThreadViewController

@synthesize navBar = _navBar;
@synthesize questions = _questions;
@synthesize student = _student;
@synthesize webView = _webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navBar.title = self.student;
    
    // create URL for mobile-friendly thread view
    NSURL* url = [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"discuss/posts/mobile/%@", [self.questions componentsJoinedByString:@","]]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight ||
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
