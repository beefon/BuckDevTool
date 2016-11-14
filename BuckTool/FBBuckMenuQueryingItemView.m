//
//  FBBuckMenuQueryingItemVuew.m
//  BuckTool
//
//  Created by Vladislav Alexeev on 04/11/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "FBBuckMenuQueryingItemView.h"

#import <QuartzCore/CoreImage.h>

@interface FBBuckMenuQueryingItemView ()

@property (nonatomic, strong) NSTextField *label;
@property (nonatomic, strong) NSProgressIndicator *spinner;

@end

@implementation FBBuckMenuQueryingItemView

- (instancetype)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self addSubview:self.label];
    [self addSubview:self.spinner];
  }
  return self;
}

- (NSTextField *)label
{
  if (_label == nil) {
    _label = [[NSTextField alloc] initWithFrame:CGRectZero];
    _label.bordered = NO;
    _label.bezeled = NO;
    _label.drawsBackground = NO;
    _label.selectable = NO;
    _label.editable = NO;
    _label.font = [NSFont menuFontOfSize:14];
  }
  return _label;
}

- (NSProgressIndicator *)spinner
{
  if (_spinner == nil) {
    _spinner = [[NSProgressIndicator alloc] init];
    _spinner.style = NSProgressIndicatorSpinningStyle;
    _spinner.displayedWhenStopped = NO;
    _spinner.bezeled = NO;
    _spinner.controlSize = NSControlSizeSmall;
    _spinner.usesThreadedAnimation = YES;
  }
  return _spinner;
}

- (void)didStartTracking
{
  self.label.textColor = [NSColor selectedMenuItemTextColor];
}

- (void)didStopTracking
{
  self.label.textColor = [NSColor textColor];
}

- (void)viewDidMoveToWindow
{
  [super viewDidMoveToWindow];
  if (self.animatingSpinner) {
    [self.spinner performSelector:@selector(startAnimation:) withObject:self afterDelay:0.0 inModes:@[NSEventTrackingRunLoopMode]];
  } else {
    [self.spinner stopAnimation:nil];
  }
}

- (void)setAnimatingSpinner:(BOOL)animatingSpinner
{
  if (_animatingSpinner != animatingSpinner) {
    _animatingSpinner = animatingSpinner;
    if (self.animatingSpinner) {
      [self.spinner performSelector:@selector(startAnimation:) withObject:self afterDelay:0.0 inModes:@[NSEventTrackingRunLoopMode]];
    } else {
      [self.spinner stopAnimation:nil];
    }
  }
}

- (void)layoutInContentRect:(NSRect)rect
{
  [super layoutInContentRect:rect];
  [self.spinner sizeToFit];
  self.spinner.frame = CGRectMake(
                                  NSMaxX(rect) - NSWidth(self.spinner.bounds),
                                  ceil(NSMidY(rect) - NSMidY(self.spinner.bounds)),
                                  NSWidth(self.spinner.bounds),
                                  NSHeight(self.spinner.bounds));
  [self.label sizeToFit];
  self.label.frame = CGRectMake(
                                NSMinX(rect),
                                ceil(NSMidY(rect) - NSMidY(self.label.bounds)) + 1,
                                NSWidth(rect) - NSWidth(self.spinner.bounds) - 5,
                                NSHeight(self.label.bounds));
}

@end
