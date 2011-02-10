//
//  BBViewController.h
//  Bubbles
//
//  Created by Kazuya Takeshima on 11/02/01.
//  Copyright 2011 Kazuya Takeshima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBView.h"

@interface BBViewController : UIViewController
  <UIActionSheetDelegate,
   UINavigationControllerDelegate,
   UIImagePickerControllerDelegate>
{
  BBView* bbView;
  UIToolbar* toolbar;
  UIBarButtonItem* cameraButton;
  UIBarButtonItem* previewButton;
  UIBarButtonItem* saveButton;
}

@end
