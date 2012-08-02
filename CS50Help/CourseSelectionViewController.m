//
//  CourseSelectionViewController.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthViewController.h"
#import "Course.h"
#import "CourseSelectionViewController.h"
#import "ServerController.h"

@implementation CourseSelectionViewController

@synthesize courses = _courses;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Select your suite";
    self.courses = [[NSMutableArray alloc] init];
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
    return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    Course* course = [self.courses objectAtIndex:indexPath.row];
    cell.textLabel.text = course.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // show authentication controller for the selected course
    Course* course = [self.courses objectAtIndex:indexPath.row];
    
    // remember the selected suite
    ServerController* serverController = [ServerController sharedInstance];
    serverController.suiteId = course.suiteId;
    
    // create auth controller
    AuthViewController* authViewController = [[AuthViewController alloc] initWithCourse:course];
    authViewController.delegate = serverController;
    
    // display auth controller so user can log in
    [self.navigationController pushViewController:authViewController animated:YES];
}

@end
