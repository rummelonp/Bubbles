//
//  BBView.m
//  Bubbles
//
//  Created by Kazuya Takeshima on 11/02/02.
//  Copyright 2011 Kazuya Takeshima. All rights reserved.
//

#import "BBView.h"

@implementation BBView

- (id)initWithFrame:(CGRect)frame
{
  LOG_METHOD;

  self = [super initWithFrame:frame];
  if (self != nil) {
    [self setUserInteractionEnabled:YES];
    UITapGestureRecognizer* singleTapGesture = [UITapGestureRecognizer alloc];
    [singleTapGesture initWithTarget:self
                              action:@selector(onSingleTap:)];
    [singleTapGesture setNumberOfTapsRequired:1];
    [self addGestureRecognizer:singleTapGesture];
    [singleTapGesture release];
  }

  return self;
}

- (void)drawRect:(CGRect)rect
{
  LOG_METHOD;

  if (baseImage != nil) {
    [baseImage drawInRect:rect];
  }
}

- (void)setImage:(UIImage*)image
{
  LOG_METHOD;

  if (baseImage != nil) {
    [baseImage release];
  }
  baseImage = image;
  [baseImage retain];
  [self setNeedsDisplay];
}

- (void)onSingleTap:(UITapGestureRecognizer*)sender
{
  LOG_METHOD;
}

- (void)dealloc
{
  LOG_METHOD;

  if (baseImage != nil) {
    [baseImage release];
    baseImage = nil;
  }
  [super dealloc];
}


@end
