//
//  AuthViewController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthViewController.h"
#import "Suite.h"
#import "ServerController.h"

@implementation AuthViewController

@synthesize suite = _suite;
@synthesize delegate = _delegate;
@synthesize webView = _webView;

- (id)initWithSuite:(Suite*)suite
{
    self = [super init];
    
    if (self) {
        self.suite = suite;
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Log in";
    
    self.webView.delegate = self;
    NSURL* url = [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"login/%d?noswitch=1&mobile=1", self.suite.orgId]];

    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    // cs50:// scheme means that we have authenticated
    if ([request.URL.scheme isEqualToString:@"cs50"]) {
        // authentication URL has form cs50://sessid
        [self.delegate didAuthenticateWithSession:request.URL.host];
        
        return NO;
    }
    
    else
        return YES;
}

@end
