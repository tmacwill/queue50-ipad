//
//  RootViewController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CS50HelpAppDelegate.h"
#import "DetailViewController.h"
#import "HalfViewController.h"
#import "ThreadViewController.h"
#import "RootViewController.h"
#import "ServerController.h"
#import "Token.h"

@implementation RootViewController

@synthesize activityIndicator = _activityIndicator;
@synthesize canAsk = _canAsk;
@synthesize categoryBackgroundColors = _categoryBackgroundColors;
@synthesize categoryForegroundColors = _categoryForegroundColors;
@synthesize containerView = _containerView;
@synthesize halfViewController = _halfViewController;
@synthesize labels = _labels;
@synthesize refreshButton = _refreshButton;
@synthesize queueButton = _queueButton;
@synthesize searchBar = _searchBar;
@synthesize searching = _searching;
@synthesize searchResults = _searchResults;
@synthesize tableView = _tableView;
@synthesize tableViewCell = _tableViewCell;
@synthesize tokens = _tokens;
@synthesize toolbar = _toolbar;

- (void)awakeFromNib
{
    // initialize models
    self.tokens = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    self.labels = [[NSMutableArray alloc] init];
    
    // initialize view-related properties
    self.searching = NO;
    self.canAsk = NO;
    self.activityIndicator.hidden = YES;
    
    // create border around tableview
    self.containerView.layer.cornerRadius = 5.0;
    self.containerView.layer.borderColor = [UIColor grayColor].CGColor;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.borderWidth = 0.5;
        
    // colors for category labels
    self.categoryBackgroundColors = [[NSArray alloc] initWithObjects:
                                     UIColorFromRGB(0xc75645),
                                     UIColorFromRGB(0x8eb33b),
                                     UIColorFromRGB(0xd0b03c),
                                     UIColorFromRGB(0x72b3cc),
                                     UIColorFromRGB(0xc8a0d1),
                                     UIColorFromRGB(0x218693),
                                     UIColorFromRGB(0xc0c0c0),
                                     UIColorFromRGB(0x5d5d5d),
                                     UIColorFromRGB(0xe09690),
                                     UIColorFromRGB(0xcdee69),
                                     UIColorFromRGB(0xffe377),
                                     UIColorFromRGB(0x9cd9f0),
                                     UIColorFromRGB(0xfbb1f9),
                                     UIColorFromRGB(0x77dfd8),
                                     UIColorFromRGB(0xf7f7f7),
                                     UIColorFromRGB(0x000000),
                                     nil];
    
    self.categoryForegroundColors = [[NSArray alloc] initWithObjects:
                                     UIColorFromRGB(0xffffff),
                                     UIColorFromRGB(0xffffff),
                                     UIColorFromRGB(0xffffff),
                                     UIColorFromRGB(0xffffff),
                                     UIColorFromRGB(0xffffff),
                                     UIColorFromRGB(0xffffff),
                                     UIColorFromRGB(0xffffff),
                                     UIColorFromRGB(0xffffff),
                                     UIColorFromRGB(0xffffff),
                                     UIColorFromRGB(0x2b5129),
                                     UIColorFromRGB(0x816f2f),
                                     UIColorFromRGB(0x174f69),
                                     UIColorFromRGB(0x8d52a0),
                                     UIColorFromRGB(0x325c5a),
                                     UIColorFromRGB(0x444444),
                                     UIColorFromRGB(0xffffff),
                                     nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Table view data source

/**
 * Number of sections in the tableview
 *
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/**
 * Number of rows in the tableview
 *
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // get length of appropriate source
    if (self.searching)
        return [self.searchResults count];
    else
        return [self.tokens count];
}

/**
 * Format cell to display student name and labels associated with token
 *
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QuestionsTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // load nib if no cell available in cache
        [[NSBundle mainBundle] loadNibNamed:@"QuestionsTableViewCell" owner:self options:nil];
        cell = _tableViewCell;
        self.tableViewCell = nil;
    }
    
    // get token from appropriate source
    Token* token = nil;
    if (self.searching)
        token = [self.searchResults objectAtIndex:indexPath.row];
    else
        token = [self.tokens objectAtIndex:indexPath.row];
    
    // determine question's position in the queue
    int position = 0;
    int n = [self.tokens count];
    for (int i = 0; i < n; i++) {
        Token* t = [self.tokens objectAtIndex:i];
        if (t.tokenId == token.tokenId) {
            position = i + 1;
            break;
        }
    }
    
    // make position label gray with rounded corners
    UILabel* label = (UILabel*)[cell viewWithTag:10];
    label.text = [NSString stringWithFormat:@"%d", position];
    label.backgroundColor = [UIColor lightGrayColor];
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = 8.0;
    
    // starting coordinates for labels
    int labelIndex = 20;
    int x = 41;
    
    // iterate through labels to display each one
    if (token.labels) {
        for (NSString* tokenLabel in token.labels) {
            // get next label in sequence by its tag and show it
            label = (UILabel*)[cell viewWithTag:labelIndex++];
            label.hidden = NO;
            label.textAlignment = UITextAlignmentCenter;
            
            // display label at current x position
            label.frame = CGRectMake(x, 31, 43, 21);
            
            // size label to fit text
            label.text = tokenLabel;
            [label sizeToFit];
            
            // add padding
            CGRect paddedFrame = label.frame;
            paddedFrame.size.width += 6;
            paddedFrame.size.height += 4;
            label.frame = paddedFrame;
            
            // color label corresponding to category
            int colorIndex = [self.labels indexOfObject:tokenLabel] % self.categoryBackgroundColors.count;
            label.backgroundColor = [self.categoryBackgroundColors objectAtIndex:colorIndex];
            label.textColor = [self.categoryForegroundColors objectAtIndex:colorIndex];
            label.layer.cornerRadius = 3.0;
            
            // move next label to the right of this label
            x += label.frame.size.width + 5;
            
            // stop displaying labels if we have run out of space
            if (x > 500)
                break;
        }
    }
    
    // make sure remaining labels are hidden
    for (int i = labelIndex; i < 25; i++) {
        label = (UILabel*)[cell viewWithTag:i];
        label.hidden = YES;
    }
         
    // student's name
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:11];
    nameLabel.text = token.student;
    
    // format cell depending on whether or not it is selected
    [self applySelectionFormattingToCell:cell atIndexPath:indexPath];
    
    return cell;
}

/**
 * Height for a given row
 *
 */
- (CGFloat)tableView:(UITableView *)tblView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

/**
 * Apply formatting to the given cell depending on whether or not it is selected
 *
 */
- (void)applySelectionFormattingToCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    // cell is selected
    if ([self.tableView.indexPathsForSelectedRows containsObject:indexPath]) {
        // light gray background
        cell.backgroundColor = [UIColor colorWithRed:238.0 / 255.0 green:238.0 / 255.0 blue:238.0 / 255.0 alpha:1.0];
        
        // show checkmark
        UIImageView* checkmark = (UIImageView*)[cell viewWithTag:30];
        checkmark.hidden = NO;
    }
    
    // cell is not selected
    else {
        // white background
        cell.backgroundColor = [UIColor whiteColor];
        
        // hide checkmark
        UIImageView* checkmark = (UIImageView*)[cell viewWithTag:30];
        checkmark.hidden = YES;       
    }
}

/**
 * Get the list of currently selected tokens
 *
 */
- (NSArray*)selectedTokens
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    
    // iterate over selected index paths to get questions
    for (NSIndexPath* indexPath in self.tableView.indexPathsForSelectedRows) {
        // get question from appropriate source
        if (self.searching)
            [result addObject:[self.searchResults objectAtIndex:indexPath.row]];
        else
            [result addObject:[self.tokens objectAtIndex:indexPath.row]];
    }
    
    return result;
}

/**
 * Reload the table while preserving selection, and only show questions matching the filter
 *
 */
- (void)refreshTable
{
    // reload table data
    NSArray* selectedRows = self.tableView.indexPathsForSelectedRows;
    [self.tableView reloadData];
    
    // preserve selection of rows
    for (NSIndexPath* indexPath in selectedRows) {
        // display checkmark on view
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self applySelectionFormattingToCell:cell atIndexPath:indexPath];
        
        // select cell in model
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - Table view delegate

/**
 * Row highlighted
 *
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // highlight cell
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self applySelectionFormattingToCell:cell atIndexPath:indexPath];
}

/**
 * Row de-highlighted
 *
 */
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // de-highlight cell
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self applySelectionFormattingToCell:cell atIndexPath:indexPath];
}

/**
 * Token accessory button brings up question thread
 *
 */
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // get selected token
    Token* token;
    if (self.searching)
        token = [self.searchResults objectAtIndex:indexPath.row];
    else
        token = [self.tokens objectAtIndex:indexPath.row];
    
    // create question thread view controller
    ThreadViewController* questionThreadViewController = [[ThreadViewController alloc] 
                                                                  initWithNibName:@"QuestionThreadViewController"
                                                                  bundle:nil];
    
    // send questions to webview
    questionThreadViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    questionThreadViewController.questions = token.questionIds;
    questionThreadViewController.student = token.student;
    
    // display view controller
    [self.halfViewController presentModalViewController:questionThreadViewController animated:YES];
}

#pragma mark - Search bar event handlers

/**
 * Filter visible questions based on search text
 *
 */
- (void)filterContentForSearchText:(NSString*)searchText
{
    // clear previous results
	[self.searchResults removeAllObjects]; 
	
    // iterate over all tokens
	for (Token* token in self.tokens) {
        // search within student name
        NSComparisonResult nameResult = [token.student compare:searchText 
                                                       options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)
                                                         range:NSMakeRange(0, [searchText length])];
 
        // add question to search results of name or question matches
        if (nameResult == NSOrderedSame)
            [self.searchResults addObject:token];        
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
    // refresh tableview with non-search-result data
    self.searching = NO;
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
 * Button selected on an alertview
 * tag == 0 signifies queue enable/disable confirmation
 *
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // confirmation dialog for enabling/disabling queue
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            // flip current state and send to server
            self.canAsk = !self.canAsk;
            [[ServerController sharedInstance] setCanAsk:self.canAsk];
        }
    }
}

/**
 * Toggle the state of the queue
 *
 */
- (void)toggleQueue:(id)sender
{
    NSMutableString* message = [NSMutableString stringWithString:@"Are you sure you want to "];
    if (self.canAsk)
        [message appendString:@"disable the queue?"];
    else
        [message appendString:@"enable the queue?"];

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 0;
    [alert show];
}

/**
 * Refresh the state of the app when refresh is pressed
 *
 */
- (void)refreshPressed:(id)sender
{
    [[ServerController sharedInstance] refresh];
}

@end