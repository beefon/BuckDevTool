//
//  FBBuckProcessInfo.h
//  BuckTool
//
//  Created by Vladislav Alexeev on 02/11/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBBuckProcessInfo : NSObject

- (instancetype)initWithShellInfo:(NSString *)shellInfo;

@property (nonatomic, assign, readonly) NSUInteger processID;
@property (nonatomic, copy, readonly) NSString *buckVersion;
@property (nonatomic, copy, readonly) NSString *repoPath;
@property (nonatomic, assign, readonly, getter=isBuckd) BOOL buckd;
@property (nonatomic, assign, readonly, getter=isDebugMode) BOOL debugMode;

@end
