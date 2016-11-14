//
//  FBBuckProcessInfo.m
//  BuckTool
//
//  Created by Vladislav Alexeev on 02/11/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "FBBuckProcessInfo.h"

@interface FBBuckProcessInfo ()

@property (nonatomic, strong) NSString *processIDValue;
@property (nonatomic, copy) NSString *buckVersionValue;
@property (nonatomic, copy) NSString *repoPathValue;
@property (nonatomic, strong) NSNumber *buckdValue;
@property (nonatomic, strong) NSNumber *debugModeValue;

@end

NSString *const kBuckVersionKey = @"buck.version_uid";
NSString *const kBuckdDirKey = @"buck.buckd_dir";

NSString *const kBuckdArgument = @"com.facebook.buck.cli.Main$DaemonBootstrap";
NSString *const kNoBuckdArgument = @"com.facebook.buck.cli.Main";
NSString *const kBuckDebugModeArgument = @"-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8888";

@implementation FBBuckProcessInfo

- (instancetype)initWithShellInfo:(NSString *)shellInfo
{
  self = [super init];
  if (self) {
    _debugModeValue = @NO;
    NSArray *arguments = [[shellInfo componentsSeparatedByString:@" "]
                          filteredArrayUsingPredicate:
                          [NSPredicate predicateWithBlock:^BOOL(NSString *_Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
      return [evaluatedObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0;
    }]];
    _processIDValue = [arguments firstObject];
    for (NSString *line in arguments) {
      [self parseLine:line];
    }
    
    if (_processIDValue == nil || [_processIDValue integerValue] == 0 ||
        _buckVersionValue == nil || _repoPathValue == nil || _buckdValue == nil || _debugModeValue == nil) {
      return nil;
    }
  }
  return self;
}

- (void)parseLine:(NSString *)line
{
  NSArray *keyAndValue = @[];
  if ([line hasPrefix:@"-D"] && [line containsString:@"="]) {
    keyAndValue = [[line substringFromIndex:2] componentsSeparatedByString:@"="];
  }
  
  if (keyAndValue.count == 2) {
    [self parseKey:[keyAndValue firstObject] value:[keyAndValue lastObject]];
  } else {
    [self parseArgument:line];
  }
}

- (void)parseKey:(NSString *)key value:(NSString *)value
{
  if (self.buckVersionValue == nil && [key isEqualToString:kBuckVersionKey]) {
    self.buckVersionValue = value;
    return;
  }
  
  if (self.repoPathValue == nil && [key isEqualToString:kBuckdDirKey]) {
    self.repoPathValue = [value stringByDeletingLastPathComponent];
    return;
  }
}

- (void)parseArgument:(NSString *)argument
{
  if (self.buckdValue == nil && [argument isEqualToString:kBuckdArgument]) {
    self.buckdValue = @YES;
    return;
  }
  
  if (self.buckdValue == nil && [argument isEqualToString:kNoBuckdArgument]) {
    self.buckdValue = @NO;
    return;
  }
  
  if ([argument isEqualToString:kBuckDebugModeArgument]) {
    self.debugModeValue = @YES;
    return;
  }
}

- (NSUInteger)processID
{
  return self.processIDValue.integerValue;
}

- (NSString *)buckVersion
{
  return self.buckVersionValue;
}

- (NSString *)repoPath
{
  return self.repoPathValue;
}

- (BOOL)isBuckd
{
  return self.buckdValue.boolValue;
}

- (BOOL)isDebugMode
{
  return self.debugModeValue.boolValue;
}

@end
