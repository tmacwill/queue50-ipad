//
//  RootViewController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DetailViewController.h"
#import "FilterViewController.h"
#import "RootViewController.h"
#import "Question.h"
#import "ServerController.h"

@implementation RootViewController

@synthesize containerView = _containerView;
@synthesize filterButton = _filterButton;
@synthesize filterPopover = _filterPopover;
@synthesize filterViewController = _filterViewController;
@synthesize questions = _questions;
@synthesize searchBar = _searchBar;
@synthesize searching = _searching;
@synthesize searchResults = _searchResults;
@synthesize selectedRows = _selectedRows;
@synthesize tableView = _tableView;
@synthesize tableViewCell = _tableViewCell;
@synthesize visibleQuestions = _visibleQuestions;

- (void)awakeFromNib
{    
    // create popover
    self.filterPopover = [[UIPopoverController alloc] initWithContentViewController:self.filterViewController];
    self.filterPopover.delegate = self;
    self.filterViewController.rootViewController = self;
        
    // initialize models
    self.questions = [[NSMutableArray alloc] init];
    self.visibleQuestions = [[NSMutableArray alloc] init];
    self.selectedRows = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    self.searching = NO;
    
    // create border around tableview
    self.containerView.layer.cornerRadius = 5.0;
    self.containerView.layer.borderColor = [UIColor grayColor].CGColor;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.borderWidth = 0.5;
}

- (void)filterButtonPressed
{
    [self.filterPopover presentPopoverFromBarButtonItem:self.filterButton 
                               permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // get length of appropriate source
    if (self.searching)
        return [self.searchResults count];
    else
        return [self.visibleQuestions count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QuestionsTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"QuestionsTableViewCell" owner:self options:nil];
        cell = _tableViewCell;
        self.tableViewCell = nil;
    }
    
    // get question from appropriate source
    Question* question = nil;
    if (self.searching)
        question = [self.searchResults objectAtIndex:indexPath.row];
    else
        question = [self.visibleQuestions objectAtIndex:indexPath.row];
    
    // make position label gray with rounded corners
    UILabel* label = (UILabel*)[cell viewWithTag:10];
    label.text = [NSString stringWithFormat:@"%d", question.position];
    label.backgroundColor = [UIColor lightGrayColor];
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = 8.0;
    
    // student's name
    label = (UILabel*)[cell viewWithTag:11];
    label.text = question.name;
    
    // if question text is only one line, vertical align at top rather than center
    label = (UILabel*)[cell viewWithTag:12];
    label.text = question.question;
    CGSize labelSize = [label.text sizeWithFont:label.font constrainedToSize:label.frame.size 
                                  lineBreakMode:label.lineBreakMode];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, 
                             label.frame.size.width, labelSize.height);
    
    // question category
    label = (UILabel*)[cell viewWithTag:13];
    label.text = question.category;
    
    
    if ([self.selectedRows containsObject:indexPath])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tblView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // already selected, so remove from selected rows
    if ([self.selectedRows containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedRows removeObject:indexPath];
    }
    
    // not selected yet, so add to selected rows 
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedRows addObject:indexPath];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    // clear previous results
	[self.searchResults removeAllObjects]; 
	
    // iterate over all questions
	for (Question* question in self.questions) {
        // search witin question text
        NSComparisonResult questionResult = [question.question compare:searchText 
                                                               options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)
                                                                 range:NSMakeRange(0, [searchText length])];
        // search within student name
        NSComparisonResult nameResult = [question.name compare:searchText 
                                                       options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)
                                                         range:NSMakeRange(0, [searchText length])];

        // add question to search results of name or question matches
        if (questionResult == NSOrderedSame || nameResult == NSOrderedSame)
            [self.searchResults addObject:question];        
	}
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searching = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searching = NO;
    // refresh tableview with non-search-result data
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:searchText];
    [self.tableView reloadData];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self buildVisibleQuestions];
}

- (void)buildVisibleQuestions
{
    // only show those questions whose categories are marked as shown
    [self.visibleQuestions removeAllObjects];
    for (Question* q in self.questions) {
        if ([self.filterViewController.selectedCategory isEqualToString:q.category] || 
            [self.filterViewController.selectedCategory isEqualToString:@"All"] ||
            self.filterViewController.selectedCategory == nil) {
            
            [self.visibleQuestions addObject:q];
        }
    }
    
    // reload table and continue loop of loading questions once we have received a response
    [self.tableView reloadData];
    [[ServerController sharedInstance] getQueue];
}

- (void)dismissPopover
{
    [self.filterPopover dismissPopoverAnimated:YES];
    [self buildVisibleQuestions];
}

@end
