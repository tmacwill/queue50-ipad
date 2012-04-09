//
//  RootViewController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class HalfViewController;
@class Question;

@interface RootViewController : UIViewController 
    <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;
@property (assign, nonatomic) BOOL canAsk;
@property (strong, nonatomic) NSArray* categoryBackgroundColors;
@property (strong, nonatomic) NSArray* categoryForegroundColors;
@property (weak, nonatomic) IBOutlet UIView* containerView;
@property (weak, nonatomic) IBOutlet HalfViewController* halfViewController;
@property (strong, nonatomic) NSMutableArray* labels;
@property (weak, nonatomic) IBOutlet UIBarButtonItem* queueButton;
@property (weak, nonatomic) IBOutlet UISearchBar* searchBar;
@property (assign, nonatomic) BOOL searching;
@property (strong, atomic) NSMutableArray* searchResults;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (assign, nonatomic) IBOutlet UITableViewCell* tableViewCell;
@property (strong, atomic) NSMutableArray* tokens;
@property (weak, nonatomic) IBOutlet UINavigationBar* toolbar;

- (void)applySelectionFormattingToCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
- (void)refreshTable;
- (NSArray*)selectedTokens;
- (void)filterContentForSearchText:(NSString*)searchText;
- (IBAction)toggleQueue:(id)sender;

@end
