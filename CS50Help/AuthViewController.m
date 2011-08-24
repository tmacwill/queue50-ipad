//
//  AuthViewController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthViewController.h"
#import "Course.h"
#import "ServerController.h"

@implementation AuthViewController

@synthesize course = _course;
@synthesize delegate = _delegate;
@synthesize webView = _webView;

- (id)initWithCourse:(Course*)course
{
    self = [super init];
    
    if (self) {
        self.course = course;
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Log in";
    
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:
                               [NSURL URLWithString:[BASE_URL stringByAppendingFormat:@"%@/auth/login?format=ipad&staff_required=true", self.course.url]]]];
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
    // cs50help scheme designates action from webview
    if ([request.URL.scheme isEqualToString:@"cs50help"]) {
        // authentication URL has form cs50help://user/identity/name/sessid
        NSArray* objects = [request.URL.pathComponents objectsAtIndexes:
                      [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 3)]];
        NSDictionary* user = [NSDictionary dictionaryWithObjects:objects forKeys:
                              [NSArray arrayWithObjects:@"identity", @"name", @"sessid", nil]];

        // send user to delegate
        [self.delegate didAuthenticateWithUser:user inCourse:self.course];
        return NO;
    }
    else {
        return YES;
    }
}

@end
