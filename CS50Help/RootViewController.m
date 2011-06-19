//
//  RootViewController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "FilterViewController.h"
#import "Question.h"
#import "ServerController.h"

@implementation RootViewController

//@synthesize detailViewController=_detailViewController;
@synthesize filterButton=_filterButton;
@synthesize filterPopover=_filterPopover;
@synthesize filterViewController=_filterViewController;
@synthesize questions=_questions;
@synthesize selectedRows=_selectedRows;
@synthesize visibleQuestions=_visibleQuestions;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)filterButtonPressed
{
    [self.filterPopover presentPopoverFromBarButtonItem:self.filterButton 
                               permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Students";
    self.selectedRows = [[NSMutableArray alloc] init];
    
    // create popover
    self.filterPopover = [[UIPopoverController alloc] initWithContentViewController:self.filterViewController];
    self.filterPopover.delegate = self;
    self.filterViewController.rootViewController = self;
    
    // create filter button in top-right of left panel
    self.filterButton = [[UIBarButtonItem alloc]
                         initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered 
                         target:self action:@selector(filterButtonPressed)];
    self.navigationItem.rightBarButtonItem = self.filterButton;
    
    self.questions = [[NSMutableArray alloc] init];
    self.visibleQuestions = [[NSMutableArray alloc] init];

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

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.visibleQuestions count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Question* question = [self.visibleQuestions objectAtIndex:indexPath.row];
    cell.textLabel.text = question.name;
    cell.detailTextLabel.text = question.question;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self buildVisibleQuestions];
}

- (void)buildVisibleQuestions
{
    // only show those questions whose categories are marked as shown
    [self.visibleQuestions removeAllObjects];
    for (Question* q in self.questions) {
        if ([self.filterViewController.selectedCategory isEqualToString:q.category] || 
            [self.filterViewController.selectedCategory isEqualToString:@"All"] ||
            self.filterViewController.selectedCategory == nil) {
            
            [self.visibleQuestions addObject:q];
        }
    }
    
    // reload table and continue loop of loading questions once we have received a response
    [self.tableView reloadData];
    [[ServerController sharedInstance] getQueue];
}

- (void)dismissPopover
{
    [self.filterPopover dismissPopoverAnimated:YES];
    [self buildVisibleQuestions];
}

@end
