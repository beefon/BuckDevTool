//
//  FBBuckTagView.h
//  BuckTool
//
//  Created by Vladislav Alexeev on 09/11/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FBBuckTagView : NSControl

+ (CGSize)sizeForViewWithText:(NSString *)text;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSColor *color;

@end
