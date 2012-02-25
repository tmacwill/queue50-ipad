//
//  main.m
//  CS50Help
//
//  Created by Tommy MacWilliam on 6/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CS50HelpAppDelegate.h"

int main(int argc, char *argv[])
{
    int retVal = 0;
    @autoreleasepool {
        [Parse setApplicationId:@"IwrE84o8YUVtrIGvMsztIYQ4aYVrRvOpBidzWdk1" 
                      clientKey:@"AhXYxSxmc7vGPLddTRyA9SZKGX1f4bId4jBCkzdv"];
        retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([CS50HelpAppDelegate class]));
    }
    return retVal;
}
