//
//  DetailViewController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "HalfViewController.h"
#import "Question.h"
#import "RootViewController.h"
#import "ServerController.h"
#import "TF.h"

@implementation DetailViewController

@synthesize assignedStudents = _assignedStudents;
@synthesize allTFs = _allTFs;
@synthesize containerView = _containerView;
@synthesize dutySegmentedControl = _dutySegmentedControl;
@synthesize halfViewController = _halfViewController;
@synthesize lastDispatchTimes = _lastDispatchTimes;
@synthesize onDutyTFs = _onDutyTFs;
@synthesize mode = _mode;
@synthesize searchBar = _searchBar;
@synthesize searching = _searching;
@synthesize searchResults = _searchResults;
@synthesize selectedIndexPath = _selectedIndexPath;
@synthesize tableView = _tableView;
@synthesize tableViewCell = _tableViewCell;
@synthesize titleLabel = _titleLabel;

- (void)awakeFromNib
{
    // border around right hand side
    self.containerView.layer.cornerRadius = 5.0;
    self.containerView.layer.borderColor = [UIColor grayColor].CGColor;
    self.containerView.layer.borderWidth = 0.5;
    
    self.assignedStudents = [[NSMutableDictionary alloc] init];
    self.allTFs = [[NSMutableArray alloc] init];
    self.onDutyTFs = [[NSMutableArray alloc] init];
    self.searchResults = [[NSMutableArray alloc] init];
    self.lastDispatchTimes = [[NSMutableDictionary alloc] init];
    self.searching = NO;
    self.mode = MODE_ON_DUTY;
    
    // create background thread to refresh tableview every second so dispatch timers stay updated
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTick:) userInfo:nil repeats:YES];
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
        CellIdentifier = @"Cell";
    else
        CellIdentifier = @"StaffTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) { 
        if (self.mode == MODE_ON_DUTY)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
        // all-TF mode uses custom table view cell
        else {
            [[NSBundle mainBundle] loadNibNamed:@"StaffTableViewCell" owner:self options:nil];
            cell = _tableViewCell;
            self.tableViewCell = nil;
        }
    }
    
    if (self.mode == MODE_ON_DUTY) {
        // get row from appropriate source
        TF* tf = nil;
        if (self.searching)
            tf = [self.searchResults objectAtIndex:indexPath.row];
        else
            tf = [self.onDutyTFs objectAtIndex:indexPath.row];
        
        // set name text
        cell.textLabel.text = tf.name;
        
        // get TF's last dispatch time, and don't try to set text if non-existant
        NSDate* lastDispatchTime = [self.lastDispatchTimes valueForKey:tf.name];
        if (!lastDispatchTime) {
            cell.detailTextLabel.text = @"";
            return cell;
        }
        
        // calculate time between right now and dispatch time and 
        NSTimeInterval interval = [lastDispatchTime timeIntervalSinceNow];
        long minutes = -(long)interval / 60;
        if (minutes > 10L)
            cell.textLabel.textColor = [UIColor redColor];
        else
            cell.textLabel.textColor = [UIColor blackColor];
        
        // set timer text
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"hh:mm:ss";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", minutes];
        
        // minutes:seconds, leaving this here in case we want to switch later
        // long seconds = -(long)interval % 60;
        // cell.detailTextLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    
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
            // keep track of selected TF and show confirm dialog
            self.selectedIndexPath = indexPath;
            NSString* message = [NSString stringWithFormat:@"Dispatch to %@?", tf.name];
            UIAlertView* confirm = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [confirm show];
        }
    }
    
    // open mail client on all-tf row select
    else if (self.mode == MODE_ALL) {
        TF* tf = [self.allTFs objectAtIndex:indexPath.row];

        if (tf) {
            // pre-populate with TF's email address
            MFMailComposeViewController* mail = [[MFMailComposeViewController alloc] init];
            mail.mailComposeDelegate = self;
            [mail setToRecipients:[NSArray arrayWithObjects:tf.email, nil]];
            [mail setCcRecipients:[NSArray arrayWithObjects:@"heads@cs50.net", nil]];
            [mail setSubject:@"Office Hours"];
            [mail setMessageBody:[NSString stringWithFormat:@"Hey %@,\n\nYou're scheduled for CS50 Office Hours tonight!", tf.name] isHTML:NO];
            [self.halfViewController presentModalViewController:mail animated:YES];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
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
        TF* tf;
        if (self.searching)
            tf = [self.searchResults objectAtIndex:self.selectedIndexPath.row];
        else
            tf = [self.onDutyTFs objectAtIndex:self.selectedIndexPath.row];

        // update the most recent dispatch time for selected TF
        [self.lastDispatchTimes setValue:[NSDate date] forKey:tf.name];
        [[ServerController sharedInstance] dispatchQuestionsToTF:tf];
    }
    else
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
    // add or remove TF from on duty list, depending on state of switch
    UISwitch* toggle = (UISwitch*)sender;
    TF* tf = [self.allTFs objectAtIndex:[toggle tag]];
    
    if (toggle.on) {
        [self.onDutyTFs insertObject:tf atIndex:0];
        [[ServerController sharedInstance] setArrival:tf];
    }
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
