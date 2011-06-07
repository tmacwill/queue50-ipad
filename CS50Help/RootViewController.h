//
//  RootViewController.h
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface RootViewController : UITableViewController {

}
		
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) NSMutableArray* students;

- (void)test;

@end
