//
//  DetailViewController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MODE_ON_DUTY 0
#define MODE_ALL 1

@interface DetailViewController : UIViewController <UITableViewDataSource, UITabBarDelegate> {

}

@property (nonatomic, retain) IBOutlet UISegmentedControl* dutySegmentedControl;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) NSMutableArray* allTFs;
@property (nonatomic, retain) NSMutableArray* onDutyTFs;
@property (nonatomic, assign) int mode;

- (void)buildOnDutyTFs;
- (IBAction)dutySegmentedControlChanged;

@end
