//
//  FBBuckMenuItemView.m
//  BuckTool
//
//  Created by Vladislav Alexeev on 02/11/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "FBBuckMenuItemView.h"
#import "FBBuckLabelFactory.h"
#import "FBBuckMenuItemTag.h"
#import "FBBuckTagView.h"

@interface FBBuckMenuItemView ()

@property (nonatomic, strong) NSTextField *repoPathLabel;
@property (nonatomic, strong) NSTextField *buckVersionLabel;
@property (nonatomic, strong, readonly) NSMutableArray<FBBuckTagView *> *mutableTagViews;

@property (nonatomic, strong) NSButton *openTerminal;
@property (nonatomic, strong) NSButton *openFinder;
@property (nonatomic, strong) NSButton *killProcess;

@end

@implementation FBBuckMenuItemView

- (instancetype)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _mutableTagViews = [[NSMutableArray alloc] init];
    [self addSubview:self.repoPathLabel];
    [self addSubview:self.buckVersionLabel];
    [self addSubview:self.openTerminal];
    [self addSubview:self.openFinder];
    [self addSubview:self.killProcess];
  }
  return self;
}

- (NSTextField *)repoPathLabel
{
  if (_repoPathLabel == nil) {
    _repoPathLabel = [FBBuckLabelFactory createLabel];
  }
  return _repoPathLabel;
}

- (NSTextField *)buckVersionLabel
{
  if (_buckVersionLabel == nil) {
    _buckVersionLabel = [FBBuckLabelFactory createLabel];
    _buckVersionLabel.font = [NSFont systemFontOfSize:[NSFont labelFontSize]];
  }
  return _buckVersionLabel;
}

- (NSButton *)openTerminal
{
  if (_openTerminal == nil) {
    _openTerminal = [NSButton buttonWithTitle:@">_"
                                       target:self
                                       action:@selector(openTerminal:)];
    _openTerminal.controlSize = NSControlSizeMini;
    _openTerminal.bezelStyle = NSBezelStyleInline;
    _openTerminal.toolTip = @"Open Terminal Here";
  }
  return _openTerminal;
}

- (void)openTerminal:(id)sender
{
  [self cancelTrackingWithoutAnimation];
  [self.delegate buckMenuItemViewOpenTerminal:self];
}

- (NSButton *)openFinder
{
  if (_openFinder == nil) {
    _openFinder = [NSButton buttonWithImage:[NSImage imageNamed:NSImageNameRevealFreestandingTemplate]
                                       target:self
                                       action:@selector(openFinder:)];
    _openFinder.controlSize = NSControlSizeMini;
    _openFinder.bezelStyle = NSBezelStyleInline;
    _openFinder.toolTip = @"Reveal in Finder";
  }
  return _openFinder;
}

- (void)openFinder:(id)sender
{
  [self cancelTrackingWithoutAnimation];
  [self.delegate buckMenuItemViewOpenFinder:self];
}

- (NSButton *)killProcess
{
  if (_killProcess == nil) {
    _killProcess = [NSButton buttonWithImage:[NSImage imageNamed:NSImageNameStopProgressFreestandingTemplate]
                                     target:self
                                     action:@selector(killProcess:)];
    _killProcess.controlSize = NSControlSizeMini;
    _killProcess.bezelStyle = NSBezelStyleInline;
    _killProcess.toolTip = @"SIGKILL Process";
  }
  return _killProcess;
}

- (void)killProcess:(id)sender
{
  [self cancelTrackingWithoutAnimation];
  [self.delegate buckMenuItemViewKillProcess:self];
}

- (void)didStartTracking
{
  self.repoPathLabel.textColor = [NSColor selectedMenuItemTextColor];
  self.buckVersionLabel.textColor = [NSColor selectedMenuItemTextColor];
}

- (void)didStopTracking
{
  self.repoPathLabel.textColor = [NSColor textColor];
  self.buckVersionLabel.textColor = [NSColor textColor];
}

- (void)layoutInContentRect:(NSRect)rect
{
  [super layoutInContentRect:rect];
  
  [self.repoPathLabel sizeToFit];
  self.repoPathLabel.frame = CGRectMake(
                                        NSMinX(rect),
                                        NSMaxY(rect) - NSHeight(self.repoPathLabel.frame),
                                        NSWidth(rect),
                                        NSHeight(self.repoPathLabel.frame));
  
  [self.openTerminal sizeToFit];
  self.openTerminal.frame = CGRectMake(NSMaxX(rect) - NSWidth(self.openTerminal.frame),
                                       NSMidY(self.repoPathLabel.frame) - NSMidY(self.openTerminal.frame),
                                       NSWidth(self.openTerminal.frame),
                                       NSHeight(self.openTerminal.frame));
  [self.openFinder sizeToFit];
  self.openFinder.frame = CGRectMake(NSMinX(self.openTerminal.frame) - NSWidth(self.openFinder.frame) - 5,
                                     NSMidY(self.repoPathLabel.frame) - NSMidY(self.openFinder.frame),
                                     NSWidth(self.openFinder.frame),
                                     NSHeight(self.openFinder.frame));
  [self.killProcess sizeToFit];
  self.killProcess.frame = CGRectMake(NSMinX(self.openFinder.frame) - NSWidth(self.killProcess.frame) - 5,
                                      NSMidY(self.repoPathLabel.frame) - NSMidY(self.killProcess.frame),
                                      NSWidth(self.killProcess.frame),
                                      NSHeight(self.killProcess.frame));
  
  [self.buckVersionLabel sizeToFit];
  self.buckVersionLabel.frame = CGRectMake(
                                      NSMinX(rect),
                                      NSMinY(self.repoPathLabel.frame) - NSHeight(self.buckVersionLabel.frame) - 5,
                                      NSWidth(rect),
                                      NSHeight(self.buckVersionLabel.frame));
  
  CGFloat tagOffset = 0.0;
  for (FBBuckTagView *tagView in self.mutableTagViews) {
    tagView.frame = CGRectMake(
                               NSMinX(rect) + tagOffset,
                               NSMinY(self.buckVersionLabel.frame) - NSHeight(tagView.frame) - 5,
                               NSWidth(tagView.frame),
                               NSHeight(tagView.frame));
    tagOffset += NSWidth(tagView.frame) + 5.0;
  }
}

- (void)setTags:(NSArray<FBBuckMenuItemTag *> *)tags
{
  if (_tags == tags || [_tags isEqualToArray:tags]) {
    return;
  }
  _tags = [tags copy];
  
  for (FBBuckTagView *tagView in self.mutableTagViews) {
    [tagView removeFromSuperview];
  }
  [self.mutableTagViews removeAllObjects];
  
  
  for (FBBuckMenuItemTag *tag in tags) {
    NSSize tagViewSize = [FBBuckTagView sizeForViewWithText:tag.text];
    FBBuckTagView *tagView = [[FBBuckTagView alloc] initWithFrame:CGRectMake(0, 0, tagViewSize.width, tagViewSize.height)];
    tagView.text = tag.text;
    tagView.color = tag.color;
    [self addSubview:tagView];
    [self.mutableTagViews addObject:tagView];
  }
  self.needsLayout = YES;
}

@end
