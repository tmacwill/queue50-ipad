//
//  AuthViewController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Course;

@protocol AuthViewControllerDelegate <NSObject>
- (void)didAuthenticateWithSession:(NSString*)sessid;
@end

@interface AuthViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) Course* course;
@property (strong, nonatomic) id<AuthViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIWebView* webView;

- (id)initWithCourse:(Course*)course;

@end