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
#import "QuestionThreadViewController.h"
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
        return [self.tokens count];
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
    
    // make sure remaining labels are hidden
    for (int i = labelIndex; i < 25; i++) {
        label = (UILabel*)[cell viewWithTag:i];
        label.hidden = YES;
    }
         
    // student's name
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:11];
    nameLabel.text = token.student;
    
    // apply selection formatting
    [self applySelectionFormattingToCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tblView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

- (void)applySelectionFormattingToCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath
{
    // highlight cell
    if ([self.tableView.indexPathsForSelectedRows containsObject:indexPath]) {
        // light gray background
        cell.backgroundColor = [UIColor colorWithRed:238.0 / 255.0 green:238.0 / 255.0 blue:238.0 / 255.0 alpha:1.0];
        
        // show checkmark
        UIImageView* checkmark = (UIImageView*)[cell viewWithTag:30];
        checkmark.hidden = NO;
    }
    
    // de-highlight cell
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // highlight cell
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self applySelectionFormattingToCell:cell atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // de-highlight cell
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self applySelectionFormattingToCell:cell atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // get selected token
    Token* token;
    if (self.searching)
        token = [self.searchResults objectAtIndex:indexPath.row];
    else
        token = [self.tokens objectAtIndex:indexPath.row];
    
    // create question thread view controller
    QuestionThreadViewController* questionThreadViewController = [[QuestionThreadViewController alloc] 
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
 * @param searchText Text to search for
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

@end