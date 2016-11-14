//
//  FBMenuItemView.h
//  BuckTool
//
//  Created by Vladislav Alexeev on 01/11/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FBMenuItemView : NSView

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL highlightable;
@property (nonatomic, assign) BOOL actionable;

- (void)didStartTracking;
- (void)didStopTracking;

- (void)layoutInContentRect:(NSRect)rect;

- (void)cancelTrackingWithoutAnimation;

@end
