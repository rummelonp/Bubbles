//
//  BBBubbleView.m
//  Bubbles
//
//  Created by Kazuya Takeshima on 11/02/02.
//  Copyright 2011 Kazuya Takeshima. All rights reserved.
//

#import "BBBubbleView.h"

@implementation BBBubbleView

static const float  LINE_WIDTH   = 5.0f;
static const CGSize DEFAULT_SIZE = {80.0f, 80.0f};

- (id)initWithFrame:(CGRect)frame
{
  LOG_METHOD;

  self = [super initWithFrame:frame];
  if (self != nil) {
    [self setOpaque:NO];

    UIPanGestureRecognizer* panGesture = [UIPanGestureRecognizer alloc];
    [panGesture initWithTarget:self
                        action:@selector(onPan:)];
    [self addGestureRecognizer:panGesture];
    [panGesture release];

    UIPinchGestureRecognizer* pinchGesture = [UIPinchGestureRecognizer alloc];
    [pinchGesture initWithTarget:self
                          action:@selector(onPinch:)];
    [self addGestureRecognizer:pinchGesture];
    [pinchGesture release];
  }

  return self;
}

- (void)drawRect:(CGRect)rect
{
  LOG_METHOD;

  // Calculate size.
  CGSize size = rect.size;
  CGRect bubbleRect = CGRectMake(LINE_WIDTH,
                                 LINE_WIDTH,
                                 size.width  - (LINE_WIDTH * 2),
                                 size.height - (LINE_WIDTH * 2));

  // Draw bubble.
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetRGBStrokeColor(context, 1.0f, 0.0f, 0.5f, 1.0f);
  CGContextSetLineWidth(context, LINE_WIDTH);
  CGContextStrokeEllipseInRect(context, bubbleRect);
}

- (void)onPan:(UIPanGestureRecognizer*)sender
{
  LOG_METHOD;

  // Calculate point.
  CGPoint destination = [sender locationInView:[self superview]];
  CGRect  rect  = [self frame];
  CGSize  size  = rect.size;
  CGPoint point = rect.origin;
  point.x = destination.x - (size.width  / 2);
  point.y = destination.y - (size.height / 2);
  rect.origin = point;

  // Move bubble.
  [self setFrame:rect];
  [self setNeedsDisplay];
}

- (void)onPinch:(UIPinchGestureRecognizer*)sender
{
  LOG_METHOD;

  UIGestureRecognizerState state = [sender state];

  CGPoint destination = [sender locationInView:[self superview]];
  CGRect  rect  = [self frame];
  CGSize  size  = rect.size;
  CGPoint point = rect.origin;
  CGFloat scale = [sender scale];

  // Save recognizer state.
  switch (state) {
    case UIGestureRecognizerStateBegan:
      pinchBeganScale = scale;
      pinchBeganSize = size;
      break;
    case UIGestureRecognizerStateChanged:
      break;
    case UIGestureRecognizerStateEnded:
      pinchBeganScale = 1;
      break;
  }

  // Caluclate scale.
  size.width  = pinchBeganSize.width  * scale / pinchBeganScale;
  size.height = pinchBeganSize.height * scale / pinchBeganScale;
  rect.size   = size;
  point.x = destination.x - (size.width  / 2);
  point.y = destination.y - (size.height / 2);
  rect.origin = point;

  // Resize bubble.
  [self setFrame:rect];
  [self setNeedsDisplay];
}

- (void)dealloc
{
  LOG_METHOD;

  [super dealloc];
}

+ (id)bubbleWithPoint:(CGPoint)point
{
  LOG_METHOD;

  // Calclate rect.
  CGRect rect = CGRectZero;
  rect.size   = DEFAULT_SIZE;
  rect.origin = CGPointMake(point.x - (DEFAULT_SIZE.width  / 2),
                            point.y - (DEFAULT_SIZE.height / 2));

  // Make bubble.
  BBBubbleView* bubble = [[[self class] alloc] initWithFrame:rect];

  return bubble;
}

@end
