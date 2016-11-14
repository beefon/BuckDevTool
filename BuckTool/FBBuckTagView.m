//
//  FBBuckTagView.m
//  BuckTool
//
//  Created by Vladislav Alexeev on 09/11/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "FBBuckTagView.h"
#import "FBBuckLabelFactory.h"

@interface FBBuckTagView ()

@property (nonatomic, strong) NSTextField *textField;

@end

@implementation FBBuckTagView

- (instancetype)initWithFrame:(NSRect)frameRect
{
  self = [super initWithFrame:frameRect];
  if (self) {
    _color = [NSColor blackColor];
    self.wantsLayer = YES;
    [self addSubview:self.textField];
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
  
  CGFloat maxDifference = fmaxf(1.0 - self.color.redComponent, fmaxf(1.0 - self.color.greenComponent, 1.0 - self.color.blueComponent));
  NSColor *backgroundColor = [NSColor colorWithRed:self.color.redComponent + maxDifference * 0.85
                                             green:self.color.greenComponent + maxDifference * 0.85
                                              blue:self.color.blueComponent + maxDifference * 0.85
                                             alpha:1.0];
  self.layer.backgroundColor = backgroundColor.CGColor;
  self.layer.borderColor = self.color.CGColor;
  self.layer.borderWidth = 1.0 / self.layer.contentsScale;
  self.layer.cornerRadius = 2.0;
}

- (void)layout
{
  [super layout];
  
  [self.textField sizeToFit];
  self.textField.frame = CGRectMake(0,
                                    NSMidY(self.bounds) - NSMidY(self.textField.bounds),
                                    NSWidth(self.bounds),
                                    NSHeight(self.textField.bounds));
}

+ (NSFont *)labelFont
{
  return [NSFont fontWithName:@"Menlo" size:10];
}

+ (CGSize)sizeForViewWithText:(NSString *)text
{
  CGSize size = [text sizeWithAttributes:@{NSFontAttributeName : self.class.labelFont}];
  size.width = ceil(size.width + 9);
  size.height = ceil(size.height + 2);
  return size;
}

- (NSTextField *)textField
{
  if (_textField == nil) {
    _textField = [FBBuckLabelFactory createLabel];
    _textField.alignment = NSTextAlignmentCenter;
    _textField.lineBreakMode = NSLineBreakByClipping;
    _textField.font = self.class.labelFont;
    _textField.textColor = [NSColor blackColor];
  }
  return _textField;
}

- (void)setText:(NSString *)text
{
  if ([_text isEqualToString:text]) {
    return;
  }
  _text = [text copy];
  self.textField.stringValue = text ?: @"";
  self.needsLayout = YES;
}

- (void)setColor:(NSColor *)color
{
  if ([_color isEqual:color]) {
    return;
  }
  _color = color;
  self.needsDisplay = YES;
}

@end
