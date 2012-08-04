//
//  QuestionThreadViewController.h
//  CS50 Queue
//
//  Created by Tommy MacWilliam on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreadViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem* navBar;
@property (strong, nonatomic) NSArray* questions;
@property (strong, nonatomic) NSString* student;
@property (weak, nonatomic) IBOutlet UIWebView* webView;

- (IBAction)done:(id)sender;

@end
