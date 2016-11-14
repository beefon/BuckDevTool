// Copyright 2004-present Facebook. All Rights Reserved.

#import <Foundation/Foundation.h>

@interface FBBUCKShellRunResult : NSObject

@property (nonatomic, readonly) NSInteger returnCode;
@property (nonatomic, copy, readonly) NSString *stdError;
@property (nonatomic, copy, readonly) NSString *stdOutput;

- (instancetype)initWithReturnCode:(NSInteger)returnCode
                          stdError:(NSString *)stdError
                         stdOutput:(NSString *)stdOutput;

@end
