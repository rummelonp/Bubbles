    //
//  BBViewController.m
//  Bubbles
//
//  Created by Kazuya Takeshima on 11/02/01.
//  Copyright 2011 Kazuya Takeshima. All rights reserved.
//

#import "BBViewController.h"

@implementation BBViewController

- (void)viewDidLoad
{
  LOG_METHOD;

  [super viewDidLoad];

  // Make toolbar buttons.
  cameraButton = [UIBarButtonItem alloc];
  [cameraButton initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                     target:self
                                     action:nil];

  // Make toolbar.
  toolbar = [UIToolbar alloc];
  [toolbar initWithFrame:CGRectMake(0.0f, 416.0f, 320.0f, 44.0f)];
  [toolbar setBarStyle:UIBarStyleBlack];
  [toolbar setTranslucent:YES];
  [toolbar setItems:[NSArray arrayWithObjects:cameraButton, nil]];

  // Add subviews.
  [self.view addSubview:toolbar];
}

- (void)didReceiveMemoryWarning
{
  LOG_METHOD;

  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
  LOG_METHOD;

  [super viewDidUnload];
}

- (void)dealloc
{
  LOG_METHOD;

  [cameraButton release];
  [toolbar release];
  [super dealloc];
}

@end
