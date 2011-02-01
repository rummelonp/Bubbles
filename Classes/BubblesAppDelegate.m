//
//  BubblesAppDelegate.m
//  Bubbles
//
//  Created by Kazuya Takeshima on 11/02/01.
//  Copyright 2011 Kazuya Takeshima. All rights reserved.
//

#import "BubblesAppDelegate.h"

@implementation BubblesAppDelegate

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication*)application
didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
  LOG_METHOD;

  window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  viewController = [[BBViewController alloc] init];
  [window addSubview:viewController.view];
  [window makeKeyAndVisible];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication*)application
{
  LOG_METHOD;
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
  LOG_METHOD;
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
  LOG_METHOD;
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
  LOG_METHOD;
}

- (void)applicationWillTerminate:(UIApplication*)application
{
  LOG_METHOD;

}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
  LOG_METHOD;
}

- (void)dealloc
{
  LOG_METHOD;

  [window release];
  [super dealloc];
}

@end
