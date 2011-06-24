//
//  DetailViewController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MODE_ON_DUTY 0
#define MODE_ALL 1

@interface DetailViewController : UIViewController 
    <UISplitViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray* allTFs;
@property (strong, nonatomic) IBOutlet UISegmentedControl* dutySegmentedControl;
@property (assign, nonatomic) int mode;
@property (strong, nonatomic) NSMutableArray* onDutyTFs;
@property (strong, nonatomic) NSMutableArray* selectedRows;
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UILabel* titleLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem* tfButton;

- (IBAction)dutySegmentedControlChanged;
- (IBAction)tfButtonPressed:(id)sender;
- (void)toggleTFButton;

@end
