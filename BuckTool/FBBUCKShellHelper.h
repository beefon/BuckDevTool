// Copyright 2004-present Facebook. All Rights Reserved.

#import <Foundation/Foundation.h>

@class FBBUCKShellRunResult;

typedef void(^FBBUCKShellHelperBlock)(FBBUCKShellRunResult *result);

@interface FBBUCKShellHelper : NSObject

+ (instancetype)sharedHelper;

- (void)invokeShellCommand:(NSString *)command completion:(FBBUCKShellHelperBlock)completion;

@end
