//
//  BBView.m
//  Bubbles
//
//  Created by Kazuya Takeshima on 11/02/02.
//  Copyright 2011 Kazuya Takeshima. All rights reserved.
//

#import "BBView.h"

@implementation BBView

@synthesize isPreviewing;

- (id)initWithFrame:(CGRect)frame
{
  LOG_METHOD;

  self = [super initWithFrame:frame];
  if (self != nil) {
    [self setUserInteractionEnabled:YES];

    bubbles = [[NSMutableArray alloc] init];

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

  // Draw base photo image by scale aspect fill.
  if (baseImage != nil) {
    CGRect  imageRect  = rect;
    CGSize  baseSize   = rect.size;
    CGSize  imageSize  = baseImage.size;
    CGPoint imagePoint = rect.origin;
    if ((imageSize.width / baseSize.width) < (imageSize.height / baseSize.height)) {
      float scale = imageSize.width / baseSize.width;
      imageSize.width  = baseSize.width;
      imageSize.height = imageSize.height / scale;
      imagePoint.y = (baseSize.height - imageSize.height) / 2;
    } else {
      float scale = imageSize.height / baseSize.height;
      imageSize.height = baseSize.height;
      imageSize.width  = imageSize.width / scale;
      imagePoint.x = (baseSize.width - imageSize.width) / 2;
    }
    imageRect.size   = imageSize;
    imageRect.origin = imagePoint;
    [baseImage drawInRect:imageRect];
  }

  // Draw bubbles on base image.
  if (bubbleImage != nil) {
    [bubbleImage drawInRect:rect];
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

  if ([bubbles count] > 0) {
    [BBBubbleView setHidden:YES
                withBubbles:bubbles];
    [bubbles release];
    bubbles = [[NSMutableArray alloc] init];
  }

  [self edit];
}

- (void)edit
{
  LOG_METHOD;

  if (bubbleImage != nil) {
    [bubbleImage release];
  }
  bubbleImage = nil;

  [BBBubbleView edit:bubbles];

  isPreviewing = NO;

  [self setNeedsDisplay];
}

- (void)preview
{
  LOG_METHOD;

  if (baseImage == nil) {
    return;
  }

  if (bubbleImage != nil) {
    [bubbleImage release];
  }

  bubbleImage = [BBBubbleView preview:bubbles];
  [bubbleImage retain];

  isPreviewing = YES;

  [self setNeedsDisplay];
}

- (void)onSingleTap:(UITapGestureRecognizer*)sender
{
  LOG_METHOD;

  if (isPreviewing ||
      baseImage == nil)
  {
    return;
  }

  CGPoint point = [sender locationInView:self];

  BBBubbleView* bubble = [BBBubbleView bubbleWithPoint:point
                                              delegate:self];

  [bubbles addObject:bubble];

  [self addSubview:bubble];
}

- (void)onRemoveFromSuperview:(id)bubble
{
  LOG_METHOD;

  if ([bubbles containsObject:bubble]) {
    [bubbles removeObject:bubble];
    [bubble release];
  }
}

- (void)dealloc
{
  LOG_METHOD;

  if (bubbleImage != nil) {
    [bubbleImage release];
    bubbleImage = nil;
  }
  if (baseImage != nil) {
    [baseImage release];
    baseImage = nil;
  }
  [bubbles release];
  [super dealloc];
}

@end
