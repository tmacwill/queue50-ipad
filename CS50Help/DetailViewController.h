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

@property (strong, nonatomic) IBOutlet UISegmentedControl* dutySegmentedControl;
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* allTFs;
@property (strong, nonatomic) NSMutableArray* onDutyTFs;
@property (assign, nonatomic) int mode;

- (void)buildOnDutyTFs;
- (IBAction)dutySegmentedControlChanged;

@end
