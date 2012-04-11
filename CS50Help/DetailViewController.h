//
//  DetailViewController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#define MODE_ON_DUTY 0
#define MODE_ALL 1

#define TAG_TF_NAME 10
#define TAG_STUDENT_NAMES 20

@class HalfViewController;

@interface DetailViewController : UIViewController 
    <UISplitViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate,
        UISearchBarDelegate, UISearchDisplayDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell* allStaffTableViewCell;
@property (strong, nonatomic) NSMutableArray* allTFs;
@property (weak, nonatomic) IBOutlet UIView* containerView;
@property (strong, nonatomic) NSMutableDictionary* dispatches;
@property (weak, nonatomic) IBOutlet UISegmentedControl* dutySegmentedControl;
@property (weak, nonatomic) IBOutlet HalfViewController* halfViewController;
@property (assign, nonatomic) int mode;
@property (strong, nonatomic) NSMutableArray* onDutyTFs;
@property (weak, nonatomic) IBOutlet UITableViewCell* onDutyStaffTableViewCell;
@property (weak, nonatomic) IBOutlet UISearchBar* searchBar;
@property (assign, nonatomic) BOOL searching;
@property (strong, nonatomic) NSMutableArray* searchResults;
@property (strong, nonatomic) NSIndexPath* selectedIndexPath;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;

- (IBAction)dutySegmentedControlChanged;
- (void)filterContentForSearchText:(NSString*)searchText;
- (UIButton*)notificationButtonForCell:(UITableViewCell*)cell;
- (IBAction)notificationButtonPressed:(id)sender;
- (void)onTick:(NSTimer*)timer;
- (IBAction)toggleRow:(id)sender;

@end
