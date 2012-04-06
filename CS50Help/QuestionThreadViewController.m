//
//  QuestionThreadViewController.m
//  CS50 Queue
//
//  Created by Tommy MacWilliam on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionThreadViewController.h"

@implementation QuestionThreadViewController

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
    NSString* url = [NSString stringWithFormat:@"http://dev/questions/mobile/%@", [self.questions componentsJoinedByString:@","]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
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
