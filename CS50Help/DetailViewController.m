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
@synthesize tableView=_tableView;
@synthesize tableViewCell=_tableViewCell;
@synthesize titleLabel=_titleLabel;

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
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        else {
            [[NSBundle mainBundle] loadNibNamed:@"StaffTableViewCell" owner:self options:nil];
            cell = _tableViewCell;
            self.tableViewCell = nil;
        }
    }
    
    if (self.mode == MODE_ON_DUTY) {
        TF* tf = [self.onDutyTFs objectAtIndex:indexPath.row];
        cell.textLabel.text = tf.name;
    }
    else if (self.mode == MODE_ALL) {
        TF* tf = [self.allTFs objectAtIndex:indexPath.row];
        for (UIView* contentView in cell.subviews) {
            for (UIView* view in contentView.subviews) {
                if ([view isKindOfClass:[UILabel class]]) {
                    UILabel* label = (UILabel*)view;
                    label.text = tf.name;
                    // gray out TFs who are not on duty
                    if (!tf.isOnDuty)
                        label.textColor = [UIColor grayColor];
                }
                
                else if ([view isKindOfClass:[UISwitch class]])
                    ((UISwitch*)view).tag = indexPath.row;
            }
        }
    }

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // dispatch all selected questions to selected TF
    if (self.mode == MODE_ON_DUTY) {
        [[ServerController sharedInstance] dispatchQuestionsToTFAtIndexPath:indexPath];
    }
    
    // open mail client on row select
    else if (self.mode == MODE_ALL) {
        TF* tf = [self.allTFs objectAtIndex:indexPath.row];

        MFMailComposeViewController* mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setToRecipients:[NSArray arrayWithObject:tf.email]];
        [mail setSubject:@"Office Hours"];
        [self presentModalViewController:mail animated:YES];
        
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

- (IBAction)dutySegmentedControlChanged
{
    self.mode = self.dutySegmentedControl.selectedSegmentIndex;
    [self.tableView reloadData];
}

- (IBAction)toggleRow:(id)sender
{
    UISwitch* toggle = (UISwitch*)sender;
    TF* tf = [self.allTFs objectAtIndex:[toggle tag]];
    
    if (toggle.on)
        [self.onDutyTFs addObject:tf];
    else
        [self.onDutyTFs removeObject:tf];
    
    [self.tableView reloadData];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}

@end
