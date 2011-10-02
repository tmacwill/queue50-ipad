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

@synthesize categoryBackgroundColors = _categoryBackgroundColors;
@synthesize categoryForegroundColors = _categoryForegroundColors;
@synthesize containerView = _containerView;
@synthesize filterButton = _filterButton;
@synthesize filterPopover = _filterPopover;
@synthesize filterViewController = _filterViewController;
@synthesize questions = _questions;
@synthesize searchBar = _searchBar;
@synthesize searching = _searching;
@synthesize searchResults = _searchResults;
@synthesize selectedQuestions = _selectedQuestions;
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
    self.selectedQuestions = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    self.searching = NO;
    
    // create border around tableview
    self.containerView.layer.cornerRadius = 5.0;
    self.containerView.layer.borderColor = [UIColor grayColor].CGColor;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.borderWidth = 0.5;
    
    // colors for category labels
    self.categoryBackgroundColors = [[NSArray alloc] initWithObjects:
                                     [UIColor colorWithRed:222.0 / 255.0 green:229.0 / 255.0 blue:242.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:204.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:204.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:236.0 / 255.0 green:112.0 / 255.0 blue:0.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:0.0 / 255.0 green:102.0 / 255.0 blue:51.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:0.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:102.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:222.0 / 255.0 green:229.0 / 255.0 blue:255.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:82.0 / 255.0 green:41.0 / 255.0 blue:163.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:32.0 / 255.0 green:108.0 / 255.0 blue:255.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:171.0 / 255.0 green:139.0 / 255.0 blue:0.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:255.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:133.0 / 255.0 green:79.0 / 255.0 blue:97.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:100.0 / 255.0 green:153.0 / 255.0 blue:44.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:224.0 / 255.0 green:213.0 / 255.0 blue:249.0 / 255.0 alpha:1.0],
                                     nil];
    
    self.categoryForegroundColors = [[NSArray alloc] initWithObjects:
                                     [UIColor colorWithRed:90.0 / 255.0 green:105.0 / 255.0 blue:134.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:223.0 / 255.0 green:226.0 / 255.0 blue:255.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:255.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:255.0 / 255.0 green:240.0 / 255.0 blue:255.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:241.0 / 255.0 green:245.0 / 255.0 blue:236.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:127.0 / 255.0 green:96.0 / 255.0 blue:0.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:90.0 / 255.0 green:105.0 / 255.0 blue:134.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:224.0 / 255.0 green:213.0 / 255.0 blue:249.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:224.0 / 255.0 green:236.0 / 255.0 blue:255.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:243.0 / 255.0 green:231.0 / 255.0 blue:179.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:204.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:253.0 / 255.0 green:233.0 / 255.0 blue:244.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:249.0 / 255.0 green:255.0 / 255.0 blue:239.0 / 255.0 alpha:1.0],
                                     [UIColor colorWithRed:82.0 / 255.0 green:41.0 / 255.0 blue:163.0 / 255.0 alpha:1.0],
                                     nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Table view data source

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
    
    // question text
    label = (UILabel*)[cell viewWithTag:12];
    label.text = question.question;
    // if question text is only one line, vertical align at top rather than center
    CGSize labelSize = [label.text sizeWithFont:label.font constrainedToSize:label.frame.size 
                                  lineBreakMode:label.lineBreakMode];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, 
                             label.frame.size.width, labelSize.height);
    
    // question category
    UILabel* categoryLabel = (UILabel*)[cell viewWithTag:13];
    categoryLabel.text = [NSString stringWithFormat:@" %@ ", question.category];
    // autosize label width to text width (plus padding)
    CGSize categorySize = [categoryLabel.text sizeWithFont:categoryLabel.font];
    categoryLabel.frame = CGRectMake(categoryLabel.frame.origin.x, categoryLabel.frame.origin.y, 
                                     categorySize.width, categoryLabel.frame.size.height);
    // use the category color sent from server
    categoryLabel.backgroundColor = [self.categoryBackgroundColors objectAtIndex:question.categoryColor];
    categoryLabel.textColor = [self.categoryForegroundColors objectAtIndex:question.categoryColor];
    categoryLabel.layer.cornerRadius = 4.0;
    
    // student's name
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:11];
    nameLabel.text = question.name;
    CGSize nameSize = [nameLabel.text sizeWithFont:nameLabel.font];
    // place student name to the right of the category label
    nameLabel.frame = CGRectMake(categoryLabel.frame.origin.x + categoryLabel.frame.size.width + 4,
                                 nameLabel.frame.origin.y, nameSize.width, nameLabel.frame.size.height);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get question from appropriate source
    Question* question = nil;
    if (self.searching)
        question = [self.searchResults objectAtIndex:indexPath.row];
    else
        question = [self.visibleQuestions objectAtIndex:indexPath.row];

    // if cell is selected, make sure it is highlighted
    if ([self inSelectedQuestions:question])
        cell.backgroundColor = [UIColor yellowColor];
    else
        cell.backgroundColor = [UIColor whiteColor];
}

- (CGFloat)tableView:(UITableView *)tblView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get question from appropriate source
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    Question* question = nil;
    if (self.searching)
        question = [self.searchResults objectAtIndex:indexPath.row];
    else
        question = [self.questions objectAtIndex:indexPath.row];
    
    if (question) {
        // already selected, so remove from selected rows
        if ([self inSelectedQuestions:question]) {
            cell.backgroundColor = [UIColor whiteColor];
            [self removeQuestionFromSelected:question];
        }
        
        // not selected yet, so add to selected rows 
        else {
            cell.backgroundColor = [UIColor yellowColor];
            // copy object, since it will be removed from memory on the next refresh
            [self.selectedQuestions addObject:[[Question alloc] initWithId:question.questionId
                                                                  question:question.question 
                                                                  position:question.position
                                                               studentName:question.name
                                                                  category:question.category
                                                             categoryColor:question.categoryColor]];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Search bar event handlers

/**
 * Filter visible questions based on search text
 * @param searchText [NSString*] Text to search for
 *
 */
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

/**
 * Switch to searching mode
 *
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searching = YES;
}

/**
 * Exit search mode
 *
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searching = NO;
    // refresh tableview with non-search-result data
    [self.tableView reloadData];
}

/**
 * Hide keyboard when search is pressed
 *
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
}

/**
 * Filter visible questions based on search text
 *
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:searchText];
    [self.tableView reloadData];
}

#pragma mark - Event handlers

/**
 * Parse the server response of pending questions into the table model
 *
 */
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

/**
 * Dismiss categories popover
 *
 */
- (void)dismissPopover
{
    [self.filterPopover dismissPopoverAnimated:YES];
    [self buildVisibleQuestions];
}

/**
 * Show filter popover
 *
 */
- (void)filterButtonPressed
{
    [self.filterPopover presentPopoverFromBarButtonItem:self.filterButton 
                               permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

/**
 * Check if a question is in the selected questions list
 * @param question [Question*] Question to look for
 * @return True iff question is in selected questions list
 *
 */
- (BOOL)inSelectedQuestions:(Question *)question
{
    if (!self.selectedQuestions)
        return NO;
    
    for (Question* q in self.selectedQuestions) {
        if (q.questionId == question.questionId) {
            return YES;
        }
    }
    
    return NO;
}

/**
 * Reload questions after category is selected
 *
 */
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self buildVisibleQuestions];
}

/**
 * Refresh everything and restart poll loops
 *
 */
- (IBAction)refresh:(id)sender
{
    //[[ServerController sharedInstance] refresh];
}

/**
 * Remove a question from the selected questions
 * @param question [Question*] Question to remove
 *
 */
- (void)removeQuestionFromSelected:(Question*)question
{
    if (!self.selectedQuestions)
        return;
    
    for (Question* q in self.selectedQuestions) {
        if (q.questionId == question.questionId) {
            [self.selectedQuestions removeObject:q];
        }
    }
}

@end
