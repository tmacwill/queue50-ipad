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
@synthesize dispatches = _dispatches;
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
    self.dispatches = [[NSMutableDictionary alloc] init];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searching)
        return [self.searchResults count];
    else
        return (self.mode == MODE_ON_DUTY) ? [self.onDutyTFs count] : [self.allTFs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    if (self.mode == MODE_ON_DUTY)
        CellIdentifier = @"OnDutyStaffTableViewCell";
    else
        CellIdentifier = @"AllStaffTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        if (self.mode == MODE_ON_DUTY) {
            // load OnDutyStaffTableViewCell.xib as cell for table
            [[NSBundle mainBundle] loadNibNamed:@"OnDutyStaffTableViewCell" owner:self options:nil];
            cell = _onDutyStaffTableViewCell;
            self.onDutyStaffTableViewCell = nil;
        }
        
        // all-TF mode uses custom table view cell
        else {
            // load AllStaffTableViewCell.xib as cell for table
            [[NSBundle mainBundle] loadNibNamed:@"AllStaffTableViewCell" owner:self options:nil];
            cell = _allStaffTableViewCell;
            self.allStaffTableViewCell = nil;
        }
    }
    
    // "On Duty" tab selected, so only display TFs who have been marked on duty
    if (self.mode == MODE_ON_DUTY) {
        // get row from appropriate source
        TF* tf = nil;
        if (self.searching)
            tf = [self.searchResults objectAtIndex:indexPath.row];
        else
            tf = [self.onDutyTFs objectAtIndex:indexPath.row];
        
        // set TF name
        UILabel* label = (UILabel*)[cell viewWithTag:TAG_TF_NAME];
        label.text = tf.name;
        
        // get dispatch information for this TF
        Dispatch* dispatch = [self.dispatches valueForKey:tf.name];
        
        // TF does not have a dispatch associated with them
        if (!dispatch) {
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
            for (Token* token in dispatch.tokens)
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
            NSTimeInterval interval = [dispatch.time timeIntervalSinceNow];
            long minutes = -(long)interval / 60;
            
            // display time since last dispatch inside button
            UIButton* button = [self notificationButtonForCell:cell];      
            [button setTitle:[NSString stringWithFormat:@"%d", minutes] forState:UIControlStateNormal];
            button.hidden = NO;
            
            // set button's tag to TF associated with row
            button.tag = [self.onDutyTFs indexOfObject:tf];
        }
    }
    
    // "All" tab selected, so display all staff members
    else if (self.mode == MODE_ALL) {
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
                
                // idenitify each switch by the row its in, since toggling is independent of row
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
    
    return cell;
}

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
    for (UIView* contentView in cell.subviews)
        for (UIView* view in contentView.subviews)
            if ([view isKindOfClass:[UIButton class]])
                return (UIButton*)view;
    
    return nil;
}

#pragma mark - Table view delegate

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
        
        // make sure TF exists
        if (tf) {
            // keep track of selected row to handle dispatch in alertview callback
            self.selectedIndexPath = indexPath;
            
            // display confirmation dialog
            NSString* message = [NSString stringWithFormat:@"Dispatch to %@?", tf.name];
            UIAlertView* confirm = [[UIAlertView alloc] initWithTitle:nil 
                                                              message:message
                                                             delegate:self
                                                    cancelButtonTitle:@"No"
                                                    otherButtonTitles:@"Yes", nil];
            [confirm show];
        }
    }
    
    // open mail client on all-tf row select
    /*
    else if (self.mode == MODE_ALL) {
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
    }
     */
}

- (IBAction)notificationButtonPressed:(id)sender
{
    // determine which TF to notify
    UIButton* button = (UIButton*)sender;
    TF* tf = [self.onDutyTFs objectAtIndex:button.tag];
    
    // notify TF
    [[ServerController sharedInstance] notifyTF:tf];
}

#pragma mark - Search bar event handlers

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

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searching = YES;
}

- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:searchText];
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searching = NO;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
}

#pragma mark - Event handlers

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // dispatch button pressed
    if (buttonIndex == 1) {
        // get tf from appropriate source
        TF* tf = nil;
        if (self.searching)
            tf = [self.searchResults objectAtIndex:self.selectedIndexPath.row];
        else
            tf = [self.onDutyTFs objectAtIndex:self.selectedIndexPath.row];

        // create a new dispatch object and add to list of dispatches
        Dispatch* dispatch = [[Dispatch alloc] initWithTokens:[self.halfViewController.rootViewController selectedTokens]
                                                         toTF:tf
                                                       atTime:[NSDate date]];
        [self.dispatches setValue:dispatch forKey:tf.name];
        
        // send dispatch to the server
        [[ServerController sharedInstance] dispatchTokens:[self.halfViewController.rootViewController selectedTokens]
                                                     toTF:tf];
        
        // reload table so dispatch time appears
        [self.tableView reloadData];
    }
    
    // either way, this row is no longer selected
    self.selectedIndexPath = nil;
}

- (IBAction)dutySegmentedControlChanged
{
    self.mode = self.dutySegmentedControl.selectedSegmentIndex;
    [self.tableView reloadData];
}

- (void)onTick:(NSTimer *)timer
{
    if (self.mode == MODE_ON_DUTY)
        [self.tableView reloadData];
}

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

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // hide controller once user finishes composing mail
    [controller dismissModalViewControllerAnimated:YES];
}

@end
