//
//  DetailViewController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "TF.h"

@implementation DetailViewController

@synthesize dutySegmentedControl=_dutySegmentedControl;
@synthesize allTFs=_allTFs;
@synthesize onDutyTFs=_onDutyTFs;
@synthesize mode=_mode;
@synthesize tableView=_tableView;

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
    
    self.onDutyTFs = [[NSMutableArray alloc] init];
    self.allTFs = [[NSMutableArray alloc] init];
    self.mode = MODE_ON_DUTY;
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
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
    [self.tableView reloadData];
}

@end
