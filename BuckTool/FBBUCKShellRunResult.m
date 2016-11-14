// Copyright 2004-present Facebook. All Rights Reserved.

#import "FBBUCKShellRunResult.h"

@implementation FBBUCKShellRunResult

- (instancetype)initWithReturnCode:(NSInteger)returnCode
                          stdError:(NSString *)stdError
                         stdOutput:(NSString *)stdOutput
{
  self = [super init];
  if (self) {
    _returnCode = returnCode;
    _stdError = [stdError copy];
    _stdOutput = [stdOutput copy];
  }
  return self;
}

@end
