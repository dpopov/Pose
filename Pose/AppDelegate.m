//
//  AppDelegate.m
//  Amalgam
//
//  Created by Daniel Popov on 3/3/15.
//  Copyright (c) 2015 Crusoe Ventures LLC. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

#pragma mark - Application State

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelOff];
    [MagicalRecordStack setDefaultStack:[AutoMigratingMagicalRecordStack stack]];
    [MagicalRecordStack defaultStack].saveOnApplicationWillResignActive = YES;
    [MagicalRecordStack defaultStack].saveOnApplicationWillTerminate = YES;
    return YES;
}

@end

