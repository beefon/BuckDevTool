//
//  FBBuckLabelFactory.h
//  BuckTool
//
//  Created by Vladislav Alexeev on 09/11/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSTextField;
@interface FBBuckLabelFactory : NSObject

+ (NSTextField *)createLabel;

@end
