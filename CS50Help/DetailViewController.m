//
//  DetailViewController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/5/11.
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    TF* tommy = [[TF alloc] initWithName:@"Tommy" isOnDuty:YES];
    TF* matt = [[TF alloc] initWithName:@"Rob" isOnDuty:YES];
    TF* rob = [[TF alloc] initWithName:@"Matt" isOnDuty:NO];
    
    self.onDutyTFs = [[NSMutableArray alloc] init];
    self.allTFs = [[NSMutableArray alloc] initWithObjects:tommy, matt, rob, nil];
    self.mode = MODE_ON_DUTY;
    
    [self buildOnDutyTFs];
    
    [tommy release];
    [matt release];
    [rob release];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
    
    // release properties
    self.dutySegmentedControl = nil;
    self.allTFs = nil;
    self.onDutyTFs = nil;
    self.tableView = nil;
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
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
}

- (IBAction)dutySegmentedControlChanged
{
    self.mode = self.dutySegmentedControl.selectedSegmentIndex;
    [self.tableView reloadData];
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    // release ivars
    [_allTFs release];
    [_onDutyTFs release];
    [_dutySegmentedControl release];
    [_tableView release];

    [super dealloc];
}

@end
