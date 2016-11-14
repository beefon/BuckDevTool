//
//  NSMenu+FBMenuAdditions.h
//  BuckTool
//
//  Created by Vladislav Alexeev on 07/11/2016.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSMenu (FBMenuAdditions)

- (NSMenuItem *)itemWithIdentifier:(NSString *)identifier;

@end
