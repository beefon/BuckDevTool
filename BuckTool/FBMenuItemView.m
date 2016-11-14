//
//  FBMenuItemView.m
//  BuckTool
//
//  Created by Vladislav Alexeev on 01/11/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "FBMenuItemView.h"

@interface FBMenuItemView ()

@property (nonatomic, strong) NSTrackingArea *trackingArea;
@property (nonatomic, assign) BOOL tracking;
@property (nonatomic, assign) BOOL cancellingTracking;

@end

@implementation FBMenuItemView

- (instancetype)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.wantsLayer = YES;
    _highlightable = YES;
    _enabled = YES;
    _actionable = YES;
  }
  return self;
}

- (BOOL)wantsUpdateLayer
{
  return YES;
}

- (void)updateLayer
{
  [super updateLayer];
  if (self.tracking) {
    self.layer.backgroundColor = [[NSColor selectedMenuItemColor] CGColor];
  } else {
    self.layer.backgroundColor = [[NSColor clearColor] CGColor];
  }
}

- (void)updateTrackingAreas
{
  [super updateTrackingAreas];
  if (self.trackingArea) {
    [self removeTrackingArea:self.trackingArea];
  }
  
  self.trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                   options:NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways
                                                     owner:self
                                                  userInfo:@{}];
  [self addTrackingArea:self.trackingArea];
}

- (void)setTracking:(BOOL)tracking
{
  if (!self.highlightable) {
    tracking = NO;
  }
  
  if (_tracking != tracking) {
    _tracking = tracking;
    self.needsDisplay = YES;
    
    if (_tracking) {
      [self didStartTracking];
    } else {
      [self didStopTracking];
    }
  }
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
  [super viewWillMoveToWindow:newWindow];
  self.tracking = NO;
}

- (void)viewDidMoveToWindow
{
  [super viewDidMoveToWindow];
  [self.class recursivelySetEnabled:self.enabled onSubviewsOfView:self];
}

- (void)mouseEntered:(NSEvent *)event
{
  if (!self.enabled || self.cancellingTracking) {
    return;
  }
  self.tracking = YES;
}

- (void)mouseExited:(NSEvent *)event
{
  if (!self.enabled || self.cancellingTracking) {
    return;
  }
  self.tracking = NO;
}

- (void)mouseUp:(NSEvent *)event
{
  if (self.actionable && self.enabled) {
    if (self.highlightable) {
      [self cancelTrackingWithAnimation];
    } else {
      [self cancelTrackingWithoutAnimation];
    }
  }
}

- (void)cancelTrackingWithAnimation
{
  self.cancellingTracking = YES;
  self.tracking = NO;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    self.tracking = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      NSMenuItem *item = [self enclosingMenuItem];
      NSMenu *menu = [item menu];
      [menu cancelTracking];
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (item.action) {
          [NSApp sendAction:item.action to:item.target from:item];
        }
        self.tracking = NO;
        self.cancellingTracking = NO;
      });
    });
  });
}

- (void)cancelTrackingWithoutAnimation
{
  NSMenuItem *item = [self enclosingMenuItem];
  NSMenu *menu = [item menu];
  [menu cancelTracking];
  if (item.action) {
    [NSApp sendAction:item.action to:item.target from:item];
  }
}

- (void)setEnabled:(BOOL)enabled
{
  if (_enabled != enabled) {
    _enabled = enabled;
    [self.class recursivelySetEnabled:_enabled onSubviewsOfView:self];
  }
}

+ (void)recursivelySetEnabled:(BOOL)enabled onSubviewsOfView:(NSView *)view {
  for (NSView *subview in view.subviews) {
    if ([subview respondsToSelector:@selector(setEnabled:)]) {
      NSControl *control = (NSControl *)subview;
      control.enabled = enabled;
      [self recursivelySetEnabled:enabled onSubviewsOfView:control];
    }
  }
}

- (void)didStartTracking
{
  
}

- (void)didStopTracking
{
  
}

- (void)layout
{
  NSRect contentRect = CGRectOffset(CGRectInset(self.bounds, 13, 5), 6, 0);
  [self layoutInContentRect:contentRect];
}

- (void)layoutInContentRect:(NSRect)rect
{
  
}

@end
