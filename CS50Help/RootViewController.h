//
//  RootViewController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class FilterViewController;
@class Question;

@interface RootViewController : UIViewController 
    <UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate, 
        UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSArray* categoryBackgroundColors;
@property (strong, nonatomic) NSArray* categoryForegroundColors;
@property (strong, nonatomic) IBOutlet UIView* containerView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem* filterButton;
@property (strong, nonatomic) UIPopoverController* filterPopover;
@property (strong, nonatomic) IBOutlet FilterViewController* filterViewController;
@property (strong, nonatomic) NSMutableArray* questions;
@property (strong, nonatomic) IBOutlet UISearchBar* searchBar;
@property (assign, nonatomic) BOOL searching;
@property (strong, nonatomic) NSMutableArray* searchResults;
@property (strong, nonatomic) NSMutableArray* selectedQuestions;
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (assign, nonatomic) IBOutlet UITableViewCell* tableViewCell;
@property (strong, nonatomic) NSMutableArray* visibleQuestions;

- (void)buildVisibleQuestions;
- (void)dismissPopover;
- (IBAction)filterButtonPressed;
- (void)filterContentForSearchText:(NSString*)searchText;
- (BOOL)inSelectedQuestions:(Question*)question;
- (IBAction)refresh:(id)sender;
- (void)removeQuestionFromSelected:(Question*)question;

@end
