//
//  RootViewController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterViewController;

@interface RootViewController : UITableViewController <UIPopoverControllerDelegate>

//@property (strong, nonatomic) IBOutlet DetailViewController *detailViewController;
@property (strong, nonatomic) UIBarButtonItem* filterButton;
@property (strong, nonatomic) UIPopoverController* filterPopover;
@property (strong, nonatomic) FilterViewController* filterViewController;
@property (strong, nonatomic) NSMutableArray* questions;
@property (strong, nonatomic) NSMutableArray* selectedRows;
@property (strong, nonatomic) NSMutableArray* visibleQuestions;

- (void)buildVisibleQuestions;
- (void)filterButtonPressed;

@end
