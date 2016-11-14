//
//  FBBuckMenuItemTag.m
//  BuckTool
//
//  Created by Vladislav Alexeev on 09/11/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "FBBuckMenuItemTag.h"

#import <AppKit/AppKit.h>

@implementation FBBuckMenuItemTag

- (instancetype)initWithText:(NSString *)text color:(NSColor *)color
{
  self = [super init];
  if (self) {
    _text = [text copy];
    _color = color;
  }
  return self;
}

@end
