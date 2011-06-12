//
//  main.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CS50HelpAppDelegate.h"

int main(int argc, char *argv[])
{
    int retVal = 0;
    @autoreleasepool {
        retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([CS50HelpAppDelegate class]));
    }
    return retVal;
}
