//
//  BBViewController.h
//  Bubbles
//
//  Created by Kazuya Takeshima on 11/02/01.
//  Copyright 2011 Kazuya Takeshima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBViewController : UIViewController
  <UIActionSheetDelegate,
   UINavigationControllerDelegate,
   UIImagePickerControllerDelegate>
{
  UIToolbar* toolbar;
  UIBarButtonItem* cameraButton;
}

@end
