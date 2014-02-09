//
//  SAMAppDelegate.m
//  SAMCache
//
//  Created by Sam Soffes on 9/15/13.
//  Copyright (c) 2013-2014 Sam Soffes. All rights reserved.
//

#import "SAMAppDelegate.h"

@implementation SAMAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	// TODO
	NSLog(@"There is no example app yet. Sorry.");

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
