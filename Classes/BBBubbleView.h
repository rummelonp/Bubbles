//
//  BBBubbleView.h
//  Bubbles
//
//  Created by Kazuya Takeshima on 11/02/02.
//  Copyright 2011 Kazuya Takeshima. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBBubbleViewDelegate

- (void)onRemoveFromSuperview:(id)bubble;

@end

@interface BBBubbleView : UIView
{
  id<BBBubbleViewDelegate> delegate;

  CGPoint panPointOffset;

  CGFloat pinchBeganScale;
  CGSize pinchBeganSize;
}

+ (id)bubbleWithPoint:(CGPoint)point
             delegate:(id<BBBubbleViewDelegate>)aDelegate;

+ (void)setHidden:(BOOL)hidden
      withBubbles:(NSMutableArray*)bubbles;

+ (void)edit:(NSMutableArray*)bubbles;

+ (UIImage*)preview:(NSMutableArray*)bubbles;

@end
