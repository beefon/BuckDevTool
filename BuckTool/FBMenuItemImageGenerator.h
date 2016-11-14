//
//  FBMenuItemImageGenerator.h
//  BuckTool
//
//  Created by Vladislav Alexeev on 13/09/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBMenuItemImageGenerator : NSObject

+ (NSImage *)imageWithTitle:(NSString *)text rightImage:(NSImage *)image maximumWidth:(CGFloat)width;

@end
