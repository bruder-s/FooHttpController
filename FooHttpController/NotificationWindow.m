//
//  NotificationWindow.m
//  FooHttpController
//
//  Created by Peroni Schoni on 5/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NotificationWindow.h"


@implementation NotificationWindow

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag {
  // Using NSBorderlessWindowMask results in a window without a title bar.
  self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
  if (self != nil) {
    // Start with no transparency for all drawing into the window
    [self setAlphaValue:0.9];
    // Turn off opacity so that the parts of the window that are not drawn into are transparent.
    [self setOpaque:NO];
    [self setLevel:NSFloatingWindowLevel];
    [self setBackgroundColor:[NSColor darkGrayColor]];
  }
  return self;
}

-(void)startFadeout:(NSTimer *)timer {
  [self orderOut:self];
  _fadeoutTimer=nil;
}

-(void)showNotification {
  [self setAlphaValue:0.75];
  [self orderFrontRegardless];
  if (_fadeoutTimer!=nil) {
    [_fadeoutTimer invalidate];
    [_fadeoutTimer release];
  }
  _fadeoutTimer=[NSTimer
    scheduledTimerWithTimeInterval:5.0
    target:self
    selector:@selector(startFadeout:)
    userInfo:nil
    repeats:NO
  ];
}

@end
