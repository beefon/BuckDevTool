//
//  FBBuckMenuItemView.h
//  BuckTool
//
//  Created by Vladislav Alexeev on 02/11/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBMenuItemView.h"

@class FBBuckMenuItemTag;

@class FBBuckMenuItemView;
@protocol FBBuckMenuItemViewDelegate <NSObject>
- (void)buckMenuItemViewOpenFinder:(FBBuckMenuItemView *)sender;
- (void)buckMenuItemViewKillProcess:(FBBuckMenuItemView *)sender;
- (void)buckMenuItemViewOpenTerminal:(FBBuckMenuItemView *)sender;
@end

@interface FBBuckMenuItemView : FBMenuItemView

@property (nonatomic, weak) id<FBBuckMenuItemViewDelegate> delegate;
@property (nonatomic, strong) id representedObject;
@property (nonatomic, strong, readonly) NSTextField *repoPathLabel;
@property (nonatomic, strong, readonly) NSTextField *buckVersionLabel;
@property (nonatomic, copy) NSArray<FBBuckMenuItemTag *> *tags;

@end
