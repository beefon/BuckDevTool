//
//  FBBuckMenuQueryingItemVuew.h
//  BuckTool
//
//  Created by Vladislav Alexeev on 04/11/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBMenuItemView.h"

@interface FBBuckMenuQueryingItemView : FBMenuItemView

@property (nonatomic, strong, readonly) NSTextField *label;
@property (nonatomic, assign) BOOL animatingSpinner;

@end
