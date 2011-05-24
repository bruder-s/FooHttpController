//
//  PreferencesWindow.m
//  FooHttpController
//
//  Created by Peroni Schoni on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PreferencesWindow.h"

#import "FooHttpControllerAppDelegate.h"

@implementation PreferencesWindow

- (void)close {
  FooHttpControllerAppDelegate *fooHttpControllerAppDelegate=[NSApp delegate];
  [fooHttpControllerAppDelegate reinitializeHotkeys];
  [super close];
}

@end
