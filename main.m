//
//  main.m
//  Bubbles
//
//  Created by Kazuya Takeshima on 11/02/01.
//  Copyright 2011 Kazuya Takeshima. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char* argv[])
{
  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
  int retVal = UIApplicationMain(argc, argv, nil, @"BubblesAppDelegate");
  [pool release];
  return retVal;
}
