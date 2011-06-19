//
//  DispatchConnectionDelegate.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "DispatchConnectionDelegate.h"
#import "RootViewController.h"

@implementation DispatchConnectionDelegate

@synthesize detailViewController=_detailViewController;
@synthesize questionIndexPaths=_questionIndexPaths;
@synthesize rootViewController=_rootViewController;
@synthesize tfIndexPath=_tfIndexPath;

static DispatchConnectionDelegate* instance;

/**
 * Class is a singleton, get the only instance
 *
 */
+ (DispatchConnectionDelegate*)sharedInstance
{
    @synchronized(self) {
        if (!instance) {
            instance = [[DispatchConnectionDelegate alloc] init];
            instance.data = [[NSMutableData alloc] init];
        }
    }
    
    return instance;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    for (NSIndexPath* indexPath in self.questionIndexPaths) {
        UITableViewCell* cell = [self.rootViewController.tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [self.detailViewController.tableView deselectRowAtIndexPath:self.tfIndexPath animated:YES];
}


@end
