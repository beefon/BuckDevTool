//
//  FBMenuItemImageGenerator.m
//  BuckTool
//
//  Created by Vladislav Alexeev on 13/09/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "FBMenuItemImageGenerator.h"
#import <AppKit/AppKit.h>

@implementation FBMenuItemImageGenerator

+ (NSImage *)imageWithTitle:(NSString *)text rightImage:(NSImage *)image maximumWidth:(CGFloat)maximumWidth {
  CGFloat xImagePoint = maximumWidth - image.size.width;
  
  NSDictionary *textAttributes = @{
                                   NSFontAttributeName : [NSFont menuBarFontOfSize:0.0f],
                                   NSForegroundColorAttributeName : [NSColor whiteColor],
                                   };
  NSRect textRect = [text boundingRectWithSize:NSMakeSize(xImagePoint, 17)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:textAttributes];
  
  NSImage *result = [NSImage imageWithSize:NSMakeSize(maximumWidth, 17) flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
    [text drawInRect:textRect withAttributes:textAttributes];
    [image drawAtPoint:NSMakePoint(xImagePoint, 17.0/2.0 - image.size.height/2.0) fromRect:NSZeroRect operation:NSCompositingOperationCopy fraction:1.0];
    return YES;
  }];
  result.template = NO;
  return result;
}

@end
