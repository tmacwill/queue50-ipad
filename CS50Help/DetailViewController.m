//
//  DetailViewController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "Dispatch.h"
#import "HalfViewController.h"
#import "RootViewController.h"
#import "ServerController.h"
#import "Token.h"
#import "TF.h"

@implementation DetailViewController

@synthesize allStaffTableViewCell = _allStaffTableViewCell;
@synthesize allTFs = _allTFs;
@synthesize containerView = _containerView;
@synthesize dutySegmentedControl = _dutySegmentedControl;
@synthesize halfViewController = _halfViewController;
@synthesize onDutyStaffTableViewCell = _onDutyStaffTableViewCell;
@synthesize onDutyTFs = _onDutyTFs;
@synthesize mode = _mode;
@synthesize searchBar = _searchBar;
@synthesize searching = _searching;
@synthesize searchResults = _searchResults;
@synthesize selectedIndexPath = _selectedIndexPath;
@synthesize tableView = _tableView;
@synthesize titleLabel = _titleLabel;

- (void)awakeFromNib
{
    // border around right hand side
    self.containerView.layer.cornerRadius = 5.0;
    self.containerView.layer.borderColor = [UIColor grayColor].CGColor;
    self.containerView.layer.borderWidth = 0.5;
    
    // initialize models
    self.allTFs = [[NSMutableArray alloc] init];
    self.mode = MODE_ON_DUTY;
    self.onDutyTFs = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    self.searching = NO;
    
    // create background thread to refresh tableview every second so dispatch timers stay updated
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Table view data source

/**
 * Number of sections in the table
 *
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/**
 * Number fo rows in the table
 *
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searching)
        return [self.searchResults count];
    else
        return (self.mode == MODE_ON_DUTY) ? [self.onDutyTFs count] : [self.allTFs count];
}

/**
 * Format staff cell
 *
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    if (self.mode == MODE_ON_DUTY)
        CellIdentifier = @"OnDutyStaffTableViewCell";
    else
        CellIdentifier = @"AllStaffTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // load nib for on duty TF view
        if (self.mode == MODE_ON_DUTY) {
            // load OnDutyStaffTableViewCell.xib as cell for table
            [[NSBundle mainBundle] loadNibNamed:@"OnDutyStaffTableViewCell" owner:self options:nil];
            cell = _onDutyStaffTableViewCell;
            self.onDutyStaffTableViewCell = nil;
        }
        
        // load nib for all TF view
        else {
            // load AllStaffTableViewCell.xib as cell for table
            [[NSBundle mainBundle] loadNibNamed:@"AllStaffTableViewCell" owner:self options:nil];
            cell = _allStaffTableViewCell;
            self.allStaffTableViewCell = nil;
        }
    }
    
    // "On Duty" tab selected, so only display TFs who have been marked on duty
    if (self.mode == MODE_ON_DUTY)
        [self formatOnDutyCell:cell atIndexPath:indexPath];
    
    // "All" tab selected, so display all staff members
    else if (self.mode == MODE_ALL) 
        [self formatAllStaffCell:cell atIndexPath:indexPath];
    
    return cell;
}

/**
 * Format a cell for the "All Staff" view
 *
 */
- (void)formatAllStaffCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    // get row from appropriate source
    TF* tf = nil;
    if (self.searching)
        tf = [self.searchResults objectAtIndex:indexPath.row];
    else
        tf = [self.allTFs objectAtIndex:indexPath.row];
    
    // we can't just search by tags here, because the switch in each row has a different tag
    for (UIView* contentView in cell.subviews) {
        for (UIView* view in contentView.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel* label = (UILabel*)view;
                label.text = tf.name;
                
                // TFs who are supposed to be on duty are red
                if (tf.isOnDuty)
                    label.textColor = [UIColor redColor];
                else
                    label.textColor = [UIColor blackColor];
            }
            
            // idenitify each switch by the row it's in, since toggling is independent of row
            else if ([view isKindOfClass:[UISwitch class]]) {
                UISwitch* s = (UISwitch*)view;
                s.tag = [self.allTFs indexOfObject:tf];
                
                // because cells are re-used, we need to manually set the toggle state
                if ([self.onDutyTFs containsObject:tf])
                    s.on = YES;
                else
                    s.on = NO;
            }
        }
    }
}

/**
 * Format a cell for the "On Duty" view
 *
 */
- (void)formatOnDutyCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    // get row from appropriate source
    TF* tf = nil;
    if (self.searching)
        tf = [self.searchResults objectAtIndex:indexPath.row];
    else
        tf = [self.onDutyTFs objectAtIndex:indexPath.row];
    
    // set TF name
    UILabel* label = (UILabel*)[cell viewWithTag:TAG_TF_NAME];
    label.text = tf.name;
    
    // TF does not have a dispatch associated with them
    if (tf.state == kStateAvailable) {
        // hide notification button
        UIButton* button = [self notificationButtonForCell:cell];
        button.hidden = YES;
        
        // center TF's name in the cell
        label = (UILabel*)[cell viewWithTag:TAG_TF_NAME];
        CGRect frame = label.frame;
        frame.origin.y = 18;
        label.frame = frame;
        
        // hide list of students
        label = (UILabel*)[cell viewWithTag:TAG_STUDENT_NAMES];
        label.hidden = YES;
    }
    
    // TF does have a dispatch
    else {
        // get students associatd with this dispatch
        NSMutableArray* students = [[NSMutableArray alloc] init];
        for (Token* token in tf.tokens)
            [students addObject:token.student];
        
        // move TF's name to top of cell
        UILabel* label = (UILabel*)[cell viewWithTag:10];
        CGRect frame = label.frame;
        frame.origin.y = 6;
        label.frame = frame;
        
        // display students associated with this dispatch
        label = (UILabel*)[cell viewWithTag:TAG_STUDENT_NAMES];
        label.text = [students componentsJoinedByString:@", "];
        label.hidden = NO;
        
        // calculate time that has elapsed since this dispatch
        NSTimeInterval interval = [tf.lastDispatchTime timeIntervalSinceNow];
        long minutes = -(long)interval / 60;
        
        // display time since last dispatch inside button
        UIButton* button = [self notificationButtonForCell:cell];      
        [button setTitle:[NSString stringWithFormat:@"%ld", minutes] forState:UIControlStateNormal];
        button.hidden = NO;
        
        // if TF has been notified, button should be yellow
        if (tf.state == kStateNotified)
            button.titleLabel.textColor = [UIColor colorWithRed:202.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1.0];
        // if TF has pressed snooze, button should be red
        else if (tf.state == kStateSnoozed)
            button.titleLabel.textColor = [UIColor redColor];
        // if TF is available, button should be white
        else
            button.titleLabel.textColor = [UIColor blackColor];
        
        // set button's tag to TF associated with row
        button.tag = [self.onDutyTFs indexOfObject:tf];
    }    
}

/**
 * Height for each cell
 *
 */
- (CGFloat)tableView:(UITableView *)tblView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.mode == MODE_ON_DUTY) ? 65.0 : 44.0;
}

/**
 * Get the notification button associated with a cell
 *
 */
- (UIButton*)notificationButtonForCell:(UITableViewCell*)cell
{
    // iterate over subviews to look for notification button
    for (UIView* contentView in cell.subviews)
        for (UIView* view in contentView.subviews)
            if ([view isKindOfClass:[UIButton class]])
                return (UIButton*)view;
    
    return nil;
}

#pragma mark - Table view delegate

/**
 * Staff row seleted
 *
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // dispatch all selected questions on on-duty row select
    if (self.mode == MODE_ON_DUTY) {
        // get tf from appropriate source
        TF* tf = nil;
        if (self.searching)
            tf = [self.searchResults objectAtIndex:indexPath.row];
        else
            tf = [self.onDutyTFs objectAtIndex:indexPath.row];
        
        // make sure TF exists and we have selected students on the left side
        if (tf && [self.halfViewController.rootViewController selectedTokens].count) {
            // keep track of selected row to handle dispatch in alertview callback
            self.selectedIndexPath = indexPath;
            
            // display confirmation dialog
            NSString* message = [NSString stringWithFormat:@"Dispatch to %@?", tf.name];
            UIAlertView* confirm = [[UIAlertView alloc] initWithTitle:nil 
                                                              message:message
                                                             delegate:self
                                                    cancelButtonTitle:@"No"
                                                    otherButtonTitles:@"Yes", nil];
            confirm.tag = CONFIRM_DISPATCH;
            [confirm show];
        }
        
        // nothing actually selected
        else
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    // open mail client on all-tf row select
    else if (self.mode == MODE_ALL) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        /*
        TF* tf = [self.allTFs objectAtIndex:indexPath.row];

        if (tf) {
            // pre-populate with TF's email address
            MFMailComposeViewController* mail = [[MFMailComposeViewController alloc] init];
            mail.mailComposeDelegate = self;
            [mail setToRecipients:[NSArray arrayWithObjects:tf.email, nil]];
            [mail setSubject:@"Office Hours"];
            [mail setMessageBody:[NSString stringWithFormat:@"Hey %@,\n\nYou're scheduled for Office Hours tonight!", tf.name] isHTML:NO];
            [self.halfViewController presentModalViewController:mail animated:YES];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
              */
    }
}

/**
 * When button in on duty cell is pressed, notify the TF to finish up
 *
 */
- (IBAction)notificationButtonPressed:(id)sender
{
    // determine which TF to notify
    UIButton* button = (UIButton*)sender;
    TF* tf = [self.onDutyTFs objectAtIndex:button.tag];
    self.selectedIndexPath = [NSIndexPath indexPathForRow:button.tag inSection:1];
    
    // show confirmation dialog
    UIAlertView* confirm = [[UIAlertView alloc] initWithTitle:nil
                                                      message:[NSString stringWithFormat:@"Notfiy %@?", tf.name]
                                                     delegate:self
                                            cancelButtonTitle:@"No"
                                            otherButtonTitles:@"Yes", nil];
    confirm.tag = CONFIRM_NOTIFY;
    [confirm show];
}

#pragma mark - Search bar event handlers

/**
 * Filter search results when key is pressed
 *
 */
- (void)filterContentForSearchText:(NSString*)searchText
{
    // clear previous results
	[self.searchResults removeAllObjects]; 
    
    // determine source for search
	NSMutableArray* collection = nil;
    if (self.mode == MODE_ON_DUTY)
        collection = self.onDutyTFs;
    else if (self.mode == MODE_ALL)
        collection = self.allTFs;
    
    // iterate over all or on-duty TFs, depending on current mode
	for (TF* tf in collection) {
        // search within TF name
        NSComparisonResult result = [tf.name compare:searchText
                                             options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)
                                               range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
            [self.searchResults addObject:tf];
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
 * Filter visible staff based on search text
 *
 */
- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:searchText];
    [self.tableView reloadData];
}

/**
 * Exit search mode
 *
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
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

#pragma mark - Event handlers

/**
 * Button selected on dispatch confirmation alertview
 *
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // get tf from appropriate source
    TF* tf = nil;
    if (self.searching)
        tf = [self.searchResults objectAtIndex:self.selectedIndexPath.row];
    else
        tf = [self.onDutyTFs objectAtIndex:self.selectedIndexPath.row];
    
    // confirming a dispatch
    if (alertView.tag == CONFIRM_DISPATCH) {
        // dispatch button pressed
        if (buttonIndex == 1)
            [self dispatchSelectedStudentsToTF:tf];
        
        // either way, this row is no longer selected
        self.selectedIndexPath = nil;
    }
    
    // notification confirmed
    if (alertView.tag == CONFIRM_NOTIFY)
        // notify button pressed
        if (buttonIndex == 1)
            [self notifyTF:tf];
}

/**
 * TF is available again
 *
 */
- (void)dispatchCompleteForTF:(int)staffId
{
    // look for TF with given ID in list of on duty TFs
    for (TF* tf in self.onDutyTFs) {
        if (tf.staffId == staffId) {
            // move TF to bottom of list
            [self.onDutyTFs removeObject:tf];
            [self.onDutyTFs addObject:tf];
            
            // clear dispatch for this TF
            tf.lastDispatchTime = nil;
            tf.lastNotifyTime = nil;
            tf.state = kStateAvailable;
            tf.tokens = nil;
            
            break;
        }
    }
    
    // reload only right side to reflect changes
    [self.tableView reloadData];
}

/**
 * Dispatch all currently selected students on the right side to a given TF
 *
 */
- (void)dispatchSelectedStudentsToTF:(TF*)tf
{
    // get tokens to be dispatched
    NSArray* tokens = [self.halfViewController.rootViewController selectedTokens];
    
    // associate dispatch with TF
    tf.lastDispatchTime = [NSDate date];
    tf.state = kStateUnavailable;
    tf.tokens = tokens;
    
    // send dispatch to the server
    [[ServerController sharedInstance] dispatchTokens:tokens toTF:tf];
    
    // place TF at bottom of list
    [self.onDutyTFs removeObject:tf];
    [self.onDutyTFs addObject:tf];
    
    // mark rows as de-selected
    for (NSIndexPath* indexPath in self.halfViewController.rootViewController.tableView.indexPathsForSelectedRows)
        [self.halfViewController.rootViewController.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // remove rows from the left side
    for (Token* t in tokens) {
        [self.halfViewController.rootViewController.tokens removeObject:t];
        [self.halfViewController.rootViewController.searchResults removeObject:t];
    }
    
    // reload both sides to reflect dispatch
    [self.tableView reloadData];
    [self.halfViewController.rootViewController refreshTable];
}

/**
 * Segmented control for switching between "all" and "on duty" changed
 *
 */
- (IBAction)dutySegmentedControlChanged
{
    self.mode = self.dutySegmentedControl.selectedSegmentIndex;
    [self.tableView reloadData];
}

/**
 * Notify a TF that another student needs help
 *
 */
- (void)notifyTF:(TF*)tf
{
    // update internal state
    tf.state = kStateNotified;
    tf.lastNotifyTime = [NSDate date];
    
    // send notification to server
    [[ServerController sharedInstance] notifyTF:tf];
    [self.tableView reloadData];

}

/**
 * TF has snoozed, so change notification button state
 *
 */
- (void)snoozeTF:(int)staffId
{
    // look for TF with given ID in list of on duty TFs
    for (TF* tf in self.onDutyTFs) {
        if (tf.staffId == staffId) {
            // update TF's state
            tf.state = kStateSnoozed;

            break;
        }
    }
    
    // reload only right side to reflect changes
    [self.tableView reloadData];
}

/**
 * At each timer tick, reload the right side to update how long TFs have been with students
 *
 */
- (void)onTick:(NSTimer *)timer
{
    if (self.mode == MODE_ON_DUTY)
        [self.tableView reloadData];
}

/**
 * Switch to place a TF on or off duty toggled
 *
 */
- (IBAction)toggleRow:(id)sender
{
    // get the TF corresponding to this toggle
    UISwitch* toggle = (UISwitch*)sender;
    TF* tf = [self.allTFs objectAtIndex:[toggle tag]];
    
    // add TF to top of list of on-duty TFs when switch is turned on
    if (toggle.on) {
        [self.onDutyTFs insertObject:tf atIndex:0];
        
        // notify server of time of TF's arrival
        [[ServerController sharedInstance] setArrival:tf];
    }
    
    // remove TF from list of on-duty TFs
    else
        [self.onDutyTFs removeObject:tf];
}

#pragma mark - Mail compose delegate

/**
 * Mail composing delegate, not used right now
 *
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // hide controller once user finishes composing mail
    [controller dismissModalViewControllerAnimated:YES];
}

@end
