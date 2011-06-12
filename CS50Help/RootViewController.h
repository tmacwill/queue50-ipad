//
//  RootViewController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class FilterViewController;

@interface RootViewController : UITableViewController <UIPopoverControllerDelegate> {

}
		
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) NSMutableArray* questions;
@property (nonatomic, retain) NSMutableArray* selectedRows;
@property (nonatomic, retain) UIPopoverController* filterPopover;
@property (nonatomic, retain) FilterViewController* filterViewController;
@property (nonatomic, retain) UIBarButtonItem* filterButton;

- (void)filterButtonPressed;

@end
