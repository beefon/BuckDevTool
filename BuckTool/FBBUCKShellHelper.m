// Copyright 2004-present Facebook. All Rights Reserved.

#import "FBBUCKShellHelper.h"
#import "FBBUCKShellRunResult.h"

NSString *const FBBUCKRepoRootKey = @"FBBUCKRepoRootKey";

@interface FBBUCKShellHelper ()

@property (nonatomic, copy, readonly) NSString *repositoryRoot;
@property (nonatomic, strong, readonly) dispatch_queue_t workQueue;

@end

@implementation FBBUCKShellHelper
@synthesize repositoryRoot = _repositoryRoot;
@synthesize workQueue = _workQueue;

+ (instancetype)sharedHelper
{
  static FBBUCKShellHelper *helper = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    helper = [[self alloc] init];
  });
  return helper;
}

- (dispatch_queue_t)workQueue
{
  if (_workQueue == nil) {
    _workQueue = dispatch_queue_create("FBBUCK_SHELL_HELPER_QUEUE", nil);
  }
  return _workQueue;
}

- (void)invokeShellCommand:(NSString *)command completion:(FBBUCKShellHelperBlock)completion
{
  dispatch_async(self.workQueue, ^{
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/bin/bash";
    task.arguments = @[@"-l", @"-c", command];

    NSPipe *stdOutPipe = [NSPipe pipe];
    NSPipe *stdErrPipe = [NSPipe pipe];
    task.standardOutput = stdOutPipe;
    task.standardError = stdErrPipe;

    NSMutableData *outputData = [NSMutableData data];
    [stdOutPipe.fileHandleForReading setReadabilityHandler:^(NSFileHandle *sender) {
      [outputData appendData:[sender readDataToEndOfFile]];
    }];

    NSMutableData *errorData = [NSMutableData data];
    [stdErrPipe.fileHandleForReading setReadabilityHandler:^(NSFileHandle *sender) {
      [errorData appendData:[sender readDataToEndOfFile]];
    }];

    [task launch];
    [task waitUntilExit];

    FBBUCKShellRunResult *result = [[FBBUCKShellRunResult alloc]
                                    initWithReturnCode:task.terminationStatus
                                    stdError:[[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding]
                                    stdOutput:[[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding]];
    dispatch_async(dispatch_get_main_queue(), ^{
      completion(result);
    });
  });
}

@end
