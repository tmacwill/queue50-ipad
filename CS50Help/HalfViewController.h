//
//  HalfViewController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class FilterViewController;
@class RootViewController;

@interface HalfViewController : UIViewController

@property (strong, nonatomic) IBOutlet DetailViewController* detailViewController;
@property (strong, nonatomic) IBOutlet FilterViewController* filterViewController;
@property (strong, nonatomic) IBOutlet RootViewController* rootViewController;

@end
