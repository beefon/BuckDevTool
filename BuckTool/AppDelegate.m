//
//  AppDelegate.m
//  BuckTool
//
//  Created by Vladislav Alexeev on 13/09/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "AppDelegate.h"
#import "FBMenuItemImageGenerator.h"
#import "FBBuckMenuItemView.h"
#import "FBBUCKShellHelper.h"
#import "FBBUCKShellRunResult.h"
#import "FBBuckProcessInfo.h"
#import "FBBuckMenuQueryingItemView.h"
#import "NSMenu+FBMenuAdditions.h"
#import "FBBuckMenuItemTag.h"

@interface AppDelegate () <NSMenuDelegate, FBBuckMenuItemViewDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong, readonly) NSMenu *menu;
@property (nonatomic, assign) BOOL menuIsVisible;
@property (nonatomic, strong, readonly) NSStatusItem *statusItem;
@property (nonatomic, copy) NSArray *buckProcesses;
@property (nonatomic, assign) BOOL queryingProcesses;
@property (nonatomic, strong) NSTimer *updateTimer;

@end

NSString *const kCheckingBuckdId = @"check_buckd";

@implementation AppDelegate

@synthesize menu = _menu;
@synthesize statusItem = _statusItem;

- (NSMenu *)menu
{
  if (_menu == nil) {
    _menu =[[NSMenu alloc] initWithTitle:@""];
    _menu.delegate = self;
  }
  return _menu;
}

- (void)insertCheckingBuckdItem
{
  FBBuckMenuQueryingItemView *itemView = [[FBBuckMenuQueryingItemView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
  itemView.label.textColor = [NSColor disabledControlTextColor];
  itemView.animatingSpinner = YES;
  itemView.enabled = NO;
  
  NSMenuItem *queryItem = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
  queryItem.view = itemView;
  queryItem.identifier = kCheckingBuckdId;
  [self.menu insertItem:queryItem atIndex:0];
}

- (void)setCheckingBuckdStatus:(NSString *)status
{
  NSMenuItem *item = [self.menu itemWithIdentifier:kCheckingBuckdId];
  FBBuckMenuQueryingItemView *itemView = (FBBuckMenuQueryingItemView *)item.view;
  itemView.label.stringValue = status;
}

- (void)setAnimatingSpinner:(BOOL)animating
{
  NSMenuItem *item = [self.menu itemWithIdentifier:kCheckingBuckdId];
  FBBuckMenuQueryingItemView *itemView = (FBBuckMenuQueryingItemView *)item.view;
  itemView.animatingSpinner = animating;
}

- (void)menuNeedsUpdate:(NSMenu *)menu
{
  if (![menu itemWithIdentifier:@"check_buckd"]) {
    [self insertCheckingBuckdItem];
  }
  
  [self queryProcesses];
}

- (void)menuWillOpen:(NSMenu *)menu
{
  self.menuIsVisible = YES;
}

- (void)menuDidClose:(NSMenu *)menu
{
  self.menuIsVisible = NO;
}

- (void)queryProcesses
{
  if (self.queryingProcesses) {
    return;
  }
  self.queryingProcesses = YES;
  [self setAnimatingSpinner:YES];
  [self setCheckingBuckdStatus:@"Checking processes..."];
  [[FBBUCKShellHelper sharedHelper] invokeShellCommand:@"ps x | grep java" completion:^(FBBUCKShellRunResult *processOutput) {
    if (processOutput.returnCode != 0) {
      self.buckProcesses = @[];
    } else {
      NSMutableArray *result = [[NSMutableArray alloc] init];
      for (NSString *line in [processOutput.stdOutput componentsSeparatedByString:@"\n"]) {
        FBBuckProcessInfo *processInfo = [[FBBuckProcessInfo alloc] initWithShellInfo:line];
        if (processInfo != nil) {
          [result addObject:processInfo];
        }
      }
      self.buckProcesses = result;
    }
    if (self.buckProcesses.count == 0) {
      [self setCheckingBuckdStatus:@"Buck isn't running"];
    } else if (self.buckProcesses.count == 1) {
      [self setCheckingBuckdStatus:@"Single Buck process is running"];
    } else {
      [self setCheckingBuckdStatus:[NSString stringWithFormat:@"Found %lu Buck processes", self.buckProcesses.count]];
    }
    
    [self setAnimatingSpinner:NO];
    self.queryingProcesses = NO;
  }];
}

- (NSStatusItem *)statusItem
{
  if (_statusItem == nil) {
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    NSImage *image = [NSImage imageNamed:@"StatusBarIcon"];
    image.template = YES;
    _statusItem.image = image;
    _statusItem.menu = self.menu;
    _statusItem.highlightMode = YES;
  }
  return _statusItem;
}

- (NSTimer *)updateTimer
{
  if (_updateTimer == nil) {
    __weak typeof(self) weakSelf = self;
    _updateTimer = [NSTimer timerWithTimeInterval:5.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
      if (weakSelf.menuIsVisible) {
        [weakSelf queryProcesses];
      }
    }];
  }
  return _updateTimer;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [self statusItem];
  [[NSRunLoop currentRunLoop] addTimer:self.updateTimer forMode:NSEventTrackingRunLoopMode];
}

- (void)setBuckProcesses:(NSArray *)buckProcesses
{
  if (_buckProcesses != buckProcesses) {
    _buckProcesses = [buckProcesses copy];
    
    for (NSUInteger i = self.menu.itemArray.count - 1; i >= 1; i--) {
      [self.menu removeItemAtIndex:i];
    }
    
    for (FBBuckProcessInfo *info in _buckProcesses) {
      NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
      FBBuckMenuItemView *itemView = [[FBBuckMenuItemView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
      itemView.delegate = self;
      itemView.highlightable = NO;
      itemView.actionable = NO;
      itemView.representedObject = info;
      itemView.repoPathLabel.stringValue = info.repoPath;
      itemView.buckVersionLabel.stringValue = [NSString stringWithFormat:@"Version: %@", info.buckVersion];
      
      NSMutableArray *tags = [[NSMutableArray alloc] init];
      
      FBBuckMenuItemTag *pidTag = [[FBBuckMenuItemTag alloc]
                                   initWithText:[NSString stringWithFormat:@"pid: %lu", info.processID]
                                   color:[NSColor purpleColor]];
      [tags addObject:pidTag];
      if (!info.buckd) {
        FBBuckMenuItemTag *tag = [[FBBuckMenuItemTag alloc]
                                  initWithText:@"NO_BUCKD=1"
                                  color:[NSColor blueColor]];
        [tags addObject:tag];
      } else {
        FBBuckMenuItemTag *tag = [[FBBuckMenuItemTag alloc]
                                  initWithText:@"BUCKD"
                                  color:[NSColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:1.0]];
        [tags addObject:tag];
      }
      if (info.debugMode) {
        FBBuckMenuItemTag *debugTag = [[FBBuckMenuItemTag alloc]
                                       initWithText:@"BUCK_DEBUG_MODE=1"
                                       color:[NSColor orangeColor]];
        [tags addObject:debugTag];
      }
      
      itemView.tags = tags;
      
      item.view = itemView;
      [self.menu addItem:item];
    }
  }
}

- (void)buckMenuItemViewOpenTerminal:(FBBuckMenuItemView *)sender
{
  FBBuckProcessInfo *info = sender.representedObject;
  [[NSWorkspace sharedWorkspace] openFile:info.repoPath withApplication:@"Terminal" andDeactivate:YES];
}

- (void)buckMenuItemViewKillProcess:(FBBuckMenuItemView *)sender
{
  FBBuckProcessInfo *info = sender.representedObject;
  killpg((pid_t)info.processID, SIGKILL);
}

- (void)buckMenuItemViewOpenFinder:(FBBuckMenuItemView *)sender
{
  FBBuckProcessInfo *info = sender.representedObject;
  NSURL *URL = [NSURL fileURLWithPath:info.repoPath];
  [[NSWorkspace sharedWorkspace] openURL:URL];
}

@end
