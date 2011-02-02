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

  // Make BB view.
  bbView = [[BBView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  // Make toolbar buttons.
  cameraButton = [UIBarButtonItem alloc];
  [cameraButton initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                     target:self
                                     action:@selector(onClickCameraButton:)];

  previewButton = [UIBarButtonItem alloc];
  [previewButton initWithTitle:@"Preview"
                         style:UIBarButtonItemStyleBordered
                        target:self
                        action:@selector(onClickPreviewButton:)];

  UIBarButtonItem* flexibleSpace = [UIBarButtonItem alloc];
  [flexibleSpace initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
  [flexibleSpace autorelease];

  // Make toolbar.
  toolbar = [UIToolbar alloc];
  [toolbar initWithFrame:CGRectMake(0.0f, 416.0f, 320.0f, 44.0f)];
  [toolbar setBarStyle:UIBarStyleBlack];
  [toolbar setTranslucent:YES];
  [toolbar setItems:[NSArray arrayWithObjects:cameraButton, flexibleSpace, previewButton, nil]];

  // Add subviews.
  [self.view addSubview:bbView];
  [self.view addSubview:toolbar];
}

- (void)onClickCameraButton:(id)sender
{
  LOG_METHOD;

  UIActionSheet* cameraActionSheet = [UIActionSheet alloc];
  [cameraActionSheet initWithTitle:nil
                          delegate:self
                 cancelButtonTitle:@"Cancel"
            destructiveButtonTitle:nil
                 otherButtonTitles:@"Photo Library", @"Photo Alubm", @"Camera", nil];
  [cameraActionSheet autorelease];

  [cameraActionSheet showInView:self.view];
}

- (void)onClickPreviewButton:(id)sender
{
  LOG_METHOD;

  if (bbView.isPreviewing) {
    [bbView edit];
  } else {
    [bbView preview];
  }
}

- (void)actionSheet:(UIActionSheet*)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
  LOG_METHOD;

  UIImagePickerControllerSourceType sourceType = 0;
  switch (buttonIndex) {
    case 0:
      sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      break;
    case 1:
      sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
      break;
    case 2:
      sourceType = UIImagePickerControllerSourceTypeCamera;
      break;
    default:
      return;
  }

  if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
    return;
  }

  UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
  [imagePicker setSourceType:sourceType];
  [imagePicker setAllowsEditing:NO];
  [imagePicker setDelegate:self];
  [imagePicker autorelease];

  [self presentModalViewController:imagePicker
                          animated:YES];
}

- (void)imagePickerController:(UIImagePickerController*)picker
didFinishPickingMediaWithInfo:(NSDictionary*)info
{
  LOG_METHOD;

  [self dismissModalViewControllerAnimated:YES];

  UIImage* originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  [bbView setImage:originalImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
  LOG_METHOD;

  [self dismissModalViewControllerAnimated:YES];
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

  [previewButton release];
  [cameraButton release];
  [toolbar release];
  [bbView release];
  [super dealloc];
}

@end
