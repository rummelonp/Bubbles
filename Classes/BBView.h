//
//  BBView.h
//  Bubbles
//
//  Created by Kazuya Takeshima on 11/02/02.
//  Copyright 2011 Kazuya Takeshima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBView : UIView
{
  UIImage* baseImage;
  UIImage* bubbleImage;
  NSMutableArray* bubbles;

  BOOL isPreviewing;
}

@property (readonly) BOOL isPreviewing;

- (void)setImage:(UIImage*)image;

- (void)edit;

- (void)preview;

@end
