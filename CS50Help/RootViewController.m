//
//  RootViewController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "FilterViewController.h"
#import "Student.h"

@implementation RootViewController
		
@synthesize detailViewController=_detailViewController;
@synthesize students=_students;
@synthesize selectedRows=_selectedRows;
@synthesize filterPopover=_filterPopover;
@synthesize filterViewController=_filterViewController;
@synthesize filterButton=_filterButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    self.navigationItem.title = @"Students";
    self.selectedRows = [[NSMutableArray alloc] init];
    
    // create view controller to be displayed in popover
    self.filterViewController = [[FilterViewController alloc] init];
    // create popover
    self.filterPopover = [[UIPopoverController alloc] initWithContentViewController:self.filterViewController];
    self.filterPopover.delegate = self;
    
    // create filter button in top-right of left panel
    self.filterButton = [[UIBarButtonItem alloc]
                         initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered 
                         target:self action:@selector(filterButtonPressed)];
    self.navigationItem.rightBarButtonItem = self.filterButton;
    
    Student* arjun = [[Student alloc] initWithName:@"Arjun" question:@"I need no help" category:@"skittles.c"];
    Student* thomas = [[Student alloc] initWithName:@"Thomas" question:@"I broke rand()" category:@"skittles.c"];
    Student* mike = [[Student alloc] initWithName:@"Mike" question:@"I didn't start" category:@"greedy.c"];
    
    self.students = [[NSMutableArray alloc] initWithObjects:arjun, thomas, mike, nil];
}

- (void)filterButtonPressed
{
    [self.filterPopover presentPopoverFromBarButtonItem:self.filterButton 
                               permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    		
}
		
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.students count];
}
		
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    Student* student = [self.students objectAtIndex:indexPath.row];
    cell.textLabel.text = student.name;
    cell.detailTextLabel.text = student.question;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // already selected, so remove from selected rows and hide checkmark
    if([self.selectedRows containsObject:indexPath]) {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


@end
