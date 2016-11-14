//
//  NSMenu+FBMenuAdditions.m
//  BuckTool
//
//  Created by Vladislav Alexeev on 07/11/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "NSMenu+FBMenuAdditions.h"

@implementation NSMenu (FBMenuAdditions)

- (NSMenuItem *)itemWithIdentifier:(NSString *)identifier
{
  for (NSMenuItem *item in self.itemArray) {
    if ([item.identifier isEqualToString:identifier]) {
      return item;
    }
  }
  return nil;
}

@end
