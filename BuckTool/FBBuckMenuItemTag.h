//
//  FBBuckMenuItemTag.h
//  BuckTool
//
//  Created by Vladislav Alexeev on 09/11/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSColor;

@interface FBBuckMenuItemTag : NSObject

- (instancetype)initWithText:(NSString *)text color:(NSColor *)color;

@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSColor *color;

@end
