//
//  DetailViewController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "ServerController.h"
#import "TF.h"

@implementation DetailViewController

@synthesize allTFs=_allTFs;
@synthesize dutySegmentedControl=_dutySegmentedControl;
@synthesize onDutyTFs=_onDutyTFs;
@synthesize mode=_mode;
@synthesize selectedRows=_selectedRows;
@synthesize tableView=_tableView;
@synthesize titleLabel=_titleLabel;
@synthesize tfButton=_tfButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.allTFs = [[NSMutableArray alloc] init];
    self.onDutyTFs = [[NSMutableArray alloc] init];
    self.selectedRows = [[NSMutableArray alloc] init];
    self.mode = MODE_ON_DUTY;
    
    // seriously, why don't UIToolbars have titles
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    self.titleLabel.shadowOffset = CGSizeMake(0, 1);
    self.titleLabel.shadowColor = [UIColor colorWithWhite:1.f alpha:.5f];
    self.titleLabel.textColor = [UIColor colorWithRed:113.f/255.f green:120.f/255.f blue:127.f/255.f alpha:1.f];
    self.titleLabel.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self toggleTFButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.mode == MODE_ON_DUTY) ? [self.onDutyTFs count] : [self.allTFs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // get TF from appropriate array
    TF* tf = (self.mode == MODE_ON_DUTY) ? [self.onDutyTFs objectAtIndex:indexPath.row] : 
    [self.allTFs objectAtIndex:indexPath.row];
    
    cell.textLabel.text = tf.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // dispatch all selected questions to selected TF
    if (self.mode == MODE_ON_DUTY) {
        [[ServerController sharedInstance] dispatchQuestionsToTFAtIndexPath:indexPath];
    }
    
    else if (self.mode == MODE_ALL) {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        // already selected, so remove from selected rows and hide checkmark
        if ([self.selectedRows containsObject:indexPath]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.selectedRows removeObject:indexPath];
        }
        
        // not selected yet, so add to selected rows and show checkmark
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectedRows addObject:indexPath];
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we can only delete TFs who are on duty
    if (self.mode == MODE_ON_DUTY)
        return YES;
    else
        return NO;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // remove selected TF from model
        [self.onDutyTFs removeObjectAtIndex:indexPath.row];
        // remove selected TF from view
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Event handlers

- (void)buildOnDutyTFs
{
    // clear array and add only those TFs who are on duty
    [self.onDutyTFs removeAllObjects];
    for (TF* tf in self.allTFs) {
        if (tf.isOnDuty) {
            [self.onDutyTFs addObject:tf];
        }
    }
    
    [self.tableView reloadData];
}

- (IBAction)dutySegmentedControlChanged
{
    self.mode = self.dutySegmentedControl.selectedSegmentIndex;
    [self toggleTFButton];    
    [self.tableView reloadData];
}

- (void)toggleTFButton
{
    if (self.mode == MODE_ON_DUTY)
        self.tfButton.enabled = NO;
    else if (self.mode == MODE_ALL)
        self.tfButton.enabled = YES;    
}

- (IBAction)tfButtonPressed:(id)sender
{
    for (NSIndexPath* indexPath in self.selectedRows) {
        // mark TF as on duty
        TF* tf = [self.allTFs objectAtIndex:indexPath.row];
        tf.isOnDuty = YES;
        
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    [self.selectedRows removeAllObjects];
    [self buildOnDutyTFs];
}

@end
