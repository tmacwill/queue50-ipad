//
//  RootViewController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// OMG BEST MARCRO EVER http://cocoamatic.blogspot.com/2010/07/uicolor-macro-with-hex-values.html
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@class HalfViewController;
@class Question;
@class TF;

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
@property (weak, nonatomic) IBOutlet UIBarButtonItem* refreshButton;
@property (weak, nonatomic) IBOutlet UISearchBar* searchBar;
@property (assign, nonatomic) BOOL searching;
@property (strong, atomic) NSMutableArray* searchResults;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (assign, nonatomic) IBOutlet UITableViewCell* tableViewCell;
@property (strong, atomic) NSMutableArray* tokens;
@property (weak, nonatomic) IBOutlet UINavigationBar* toolbar;

- (void)applySelectionFormattingToCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
- (void)filterContentForSearchText:(NSString*)searchText;
- (IBAction)refreshPressed:(id)sender;
- (void)refreshTable;
- (NSArray*)selectedTokens;
- (IBAction)toggleQueue:(id)sender;

@end
