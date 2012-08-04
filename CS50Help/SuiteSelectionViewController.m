//
//  SuiteSelectionViewController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthViewController.h"
#import "Suite.h"
#import "SuiteSelectionViewController.h"
#import "ServerController.h"

@implementation SuiteSelectionViewController

@synthesize suites = _suites;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Select your suite";
    self.suites = [[NSMutableArray alloc] init];
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
    return [self.suites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    Suite* suite = [self.suites objectAtIndex:indexPath.row];
    cell.textLabel.text = suite.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // show authentication controller for the selected course
    Suite* suite = [self.suites objectAtIndex:indexPath.row];
    
    // remember the selected suite
    ServerController* serverController = [ServerController sharedInstance];
    serverController.suiteId = suite.suiteId;
    
    // create auth controller
    AuthViewController* authViewController = [[AuthViewController alloc] initWithSuite:suite];
    authViewController.delegate = serverController;
    
    // display auth controller so user can log in
    [self.navigationController pushViewController:authViewController animated:YES];
}

@end