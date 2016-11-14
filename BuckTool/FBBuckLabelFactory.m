//
//  FBBuckLabelFactory.m
//  BuckTool
//
//  Created by Vladislav Alexeev on 09/11/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "FBBuckLabelFactory.h"
#import <AppKit/NSTextField.h>
#import <AppKit/NSFont.h>
#import <AppKit/NSColor.h>

@implementation FBBuckLabelFactory

+ (NSTextField *)createLabel
{
  NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectZero];
  textField.bordered = NO;
  textField.bezeled = NO;
  textField.drawsBackground = NO;
  textField.selectable = NO;
  textField.editable = NO;
  textField.backgroundColor = [NSColor clearColor];
  textField.font = [NSFont menuFontOfSize:14];
  return textField;
}

@end
