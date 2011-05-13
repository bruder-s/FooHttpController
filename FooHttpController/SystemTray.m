//
//  SystemTray.m
//  FooHttpController
//
//  Created by Peroni Schoni on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SystemTray.h"


@implementation SystemTray

- (void) createMyTrayBar:(NSObject*)receiver {
  NSZone *menuZone = [NSMenu menuZone];
  NSMenu *menu = [[NSMenu allocWithZone:menuZone] init];
  NSMenuItem *menuItem;
  
  menuItem = [menu addItemWithTitle:@"Start" action:@selector(play:) keyEquivalent:@""];
  [menuItem setTarget:receiver];
  
  menuItem = [menu addItemWithTitle:@"Pause" action:@selector(playOrPause:) keyEquivalent:@""];
  [menuItem setTarget:receiver];
  
  menuItem = [menu addItemWithTitle:@"Stop" action:@selector(stop:) keyEquivalent:@""];
  [menuItem setTarget:receiver];
  
  menuItem = [menu addItemWithTitle:@"Previous" action:@selector(previous:) keyEquivalent:@""];
  [menuItem setTarget:receiver];
  
  menuItem = [menu addItemWithTitle:@"Next" action:@selector(next:) keyEquivalent:@""];
  [menuItem setTarget:receiver];
  
  [menu addItem:[NSMenuItem separatorItem]];
  
  menuItem = [menu addItemWithTitle:@"Quit" action:@selector(quitApp:) keyEquivalent:@""];
  [menuItem setTarget:self];
  
  _systemTray = [[[NSStatusBar systemStatusBar]
                  statusItemWithLength:NSVariableStatusItemLength] retain];
  
  [_systemTray setMenu:menu];
  [_systemTray setHighlightMode:YES];
  [_systemTray setToolTip:@"FooHttpController"];
  [_systemTray setTitle:@"F"];
  
  [menu release];
}

- (void)quitApp:(id)sender {
  [NSApp terminate: sender];
}

-(void)dealloc
{
  [_systemTray release];
}

@end
