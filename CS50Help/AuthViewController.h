//
//  AuthViewController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuthViewControllerDelegate <NSObject>
- (void)didAuthenticateWithUser:(NSDictionary*)user;
@end

@interface AuthViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) id<AuthViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIWebView* webView;

@end