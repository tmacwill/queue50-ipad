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

@class HalfViewController;

@interface DetailViewController : UIViewController 
    <UISplitViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate,
        UISearchBarDelegate, UISearchDisplayDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray* allTFs;
@property (strong, nonatomic) NSMutableDictionary* assignedStudents;
@property (strong, nonatomic) IBOutlet UIView* containerView;
@property (strong, nonatomic) IBOutlet UISegmentedControl* dutySegmentedControl;
@property (strong, nonatomic) IBOutlet HalfViewController* halfViewController;
@property (strong, nonatomic) NSMutableDictionary* lastDispatchTimes;
@property (assign, nonatomic) int mode;
@property (strong, nonatomic) NSMutableArray* onDutyTFs;
@property (strong, nonatomic) IBOutlet UISearchBar* searchBar;
@property (assign, nonatomic) BOOL searching;
@property (strong, nonatomic) NSMutableArray* searchResults;
@property (strong, nonatomic) NSIndexPath* selectedIndexPath;
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell* tableViewCell;
@property (strong, nonatomic) IBOutlet UILabel* titleLabel;

- (IBAction)dutySegmentedControlChanged;
- (void)onTick:(NSTimer*)timer;
- (IBAction)toggleRow:(id)sender;
- (void)filterContentForSearchText:(NSString*)searchText;

@end
