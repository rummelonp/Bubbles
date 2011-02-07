//
//  BBBubbleView.m
//  Bubbles
//
//  Created by Kazuya Takeshima on 11/02/02.
//  Copyright 2011 Kazuya Takeshima. All rights reserved.
//

#import "BBBubbleView.h"

@implementation BBBubbleView

static const float TOLETANCE    = 10.0f;
static const float LINE_WIDTH   = 5.0f;
static const float OFFSET_WIDTH = 10.0f;

static const int IMAGE_HEIGHT = 480;
static const int IMAGE_WIDTH  = 320;

static CGSize LAST_SIZE = {150.0f, 150.0f};

- (id)initWithFrame:(CGRect)frame
           delegate:(id<BBBubbleViewDelegate>)aDelegate
{
  LOG_METHOD;

  self = [super initWithFrame:frame];
  if (self != nil) {
    [self setOpaque:NO];

    delegate = aDelegate;

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
  CGRect bubbleRect = CGRectMake(LINE_WIDTH + OFFSET_WIDTH,
                                 LINE_WIDTH + OFFSET_WIDTH,
                                 size.width  - (LINE_WIDTH * 2) - (OFFSET_WIDTH * 2),
                                 size.height - (LINE_WIDTH * 2) - (OFFSET_WIDTH * 2));

  // Draw bubble.
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetRGBStrokeColor(context, 1.0f, 0.0f, 0.5f, 1.0f);
  CGContextSetLineWidth(context, LINE_WIDTH);
  CGContextStrokeEllipseInRect(context, bubbleRect);
}

- (BOOL)pointInBubble:(CGPoint)point
{
  float x = point.x - self.center.x;
  float y = point.y - self.center.y;
  float r = (self.frame.size.width / 2) + TOLETANCE;

  return (x * x) + (y * y) < (r * r);
}

- (void)onPan:(UIPanGestureRecognizer*)sender
{
  LOG_METHOD;

  UIGestureRecognizerState state = [sender state];

  CGPoint destination = [sender locationInView:[self superview]];
  CGRect  rect  = [self frame];
  CGSize  size  = rect.size;
  CGPoint point = rect.origin;

  if (![self pointInBubble:destination]) {
    return;
  }

  BOOL remove = NO;
  switch (state) {
    case UIGestureRecognizerStateBegan:
      panPointOffset = CGPointMake(self.center.x - destination.x,
                                   self.center.y - destination.y);
      break;
    case UIGestureRecognizerStateChanged:
      break;
    case UIGestureRecognizerStateEnded:
      if (self.center.y <= 0) {
        remove = YES;
      }
      break;
  }

  // Calculate point.
  point.x = destination.x + panPointOffset.x - (size.width  / 2);
  point.y = destination.y + panPointOffset.y - (size.height / 2);
  rect.origin = point;

  if (remove) {
    // Remove bubble.
    [self setHidden:YES];
    [self removeFromSuperview];
    if (delegate != nil) {
      [delegate onRemoveFromSuperview:self];
    }
  } else {
    // Move bubble.
    [self setFrame:rect];
    [self setNeedsDisplay];
  }
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

  // Save last size.
  LAST_SIZE = rect.size;

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
             delegate:(id<BBBubbleViewDelegate>)aDelegate
{
  LOG_METHOD;

  // Calclate rect.
  CGRect rect = CGRectZero;
  rect.size   = LAST_SIZE;
  rect.origin = CGPointMake(point.x - (LAST_SIZE.width  / 2),
                            point.y - (LAST_SIZE.height / 2));

  // Make bubble.
  BBBubbleView* bubble = [[[self class] alloc] initWithFrame:rect delegate:aDelegate];

  return bubble;
}

+ (void)setHidden:(BOOL)hidden
      withBubbles:(NSMutableArray*)bubbles
{
  LOG_METHOD;

  for (int i = 0; i < [bubbles count]; i += 1) {
    BBBubbleView* bubble = [bubbles objectAtIndex:i];
    [bubble setHidden:hidden];
  }
}

+ (void)edit:(NSMutableArray*)bubbles
{
  LOG_METHOD;

  // Show editing bubbles.
  [self setHidden:NO
      withBubbles:bubbles];
}

+ (UIImage*)preview:(NSMutableArray*)bubbles
{
  LOG_METHOD;

  // Hide editing bubbles.
  [self setHidden:YES
      withBubbles:bubbles];

  // Create bitmap context.
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context = CGBitmapContextCreate(NULL,
                                               IMAGE_WIDTH,
                                               IMAGE_HEIGHT,
                                               8,
                                               IMAGE_WIDTH * 4,
                                               colorSpace,
                                               kCGImageAlphaPremultipliedLast);

  // Draw preview bubbles.
  CGContextSetRGBFillColor(context, 1.0f, 0.0f, 0.5f, 1.0f);
  CGContextFillRect(context, [[UIScreen mainScreen] bounds]);

  for (int i = 0; i < [bubbles count]; i += 1) {
    BBBubbleView* bubble = [bubbles objectAtIndex:i];
    CGRect  rect  = [bubble frame];
    CGSize  size  = rect.size;
    CGPoint point = rect.origin;
    point.y = IMAGE_HEIGHT - (point.y + size.height);
    rect = CGRectMake(point.x + OFFSET_WIDTH,
                      point.y + OFFSET_WIDTH,
                      size.width  - LINE_WIDTH - (OFFSET_WIDTH * 2),
                      size.height - LINE_WIDTH - (OFFSET_WIDTH * 2));
    CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
    CGContextFillEllipseInRect(context, rect);
  }

  // Make temporary bitmap.
  CGImageRef imageRef = CGBitmapContextCreateImage(context);

  // Convert white to clear.
  CGDataProviderRef imageDataProvider = CGImageGetDataProvider(imageRef);
  CFDataRef imageData = CGDataProviderCopyData(imageDataProvider);
  UInt8* buffer = (UInt8*)CFDataGetBytePtr(imageData);
  size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
  NSUInteger i, j;
  for (j = 0; j < IMAGE_HEIGHT; j++) {
    for (i = 0; i < IMAGE_WIDTH; i++) {
      UInt8* tmp = buffer + (j * bytesPerRow) + (i * 4);
      UInt8 r;
      r = *tmp;
      *(tmp + 3) = r;
    }
  }

  // Make preview bubbles image.
  CFDataRef dataRef = CFDataCreate(NULL, buffer, CFDataGetLength(imageData));
  CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(dataRef);
  CGImageRef image = CGImageCreate(IMAGE_WIDTH,
                                   IMAGE_HEIGHT,
                                   CGImageGetBitsPerComponent(imageRef),
                                   CGImageGetBitsPerPixel(imageRef),
                                   bytesPerRow,
                                   colorSpace,
                                   CGImageGetBitmapInfo(imageRef),
                                   dataProvider,
                                   NULL,
                                   CGImageGetShouldInterpolate(imageRef),
                                   CGImageGetRenderingIntent(imageRef));

  return [[UIImage alloc] initWithCGImage:image];
}

@end
