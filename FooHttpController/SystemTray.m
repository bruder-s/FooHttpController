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
                  statusItemWithLength:NSSquareStatusItemLength] retain]; //NSVariableStatusItemLength
  
  [_systemTray setMenu:menu];
  [_systemTray setHighlightMode:YES];
  [_systemTray setToolTip:@"FooHttpController"];
  [_systemTray setTitle:@"F"];
  
  NSBundle *bundle = [NSBundle mainBundle];
  NSImage *statusImage=[[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"icon" ofType:@"png"]];
  NSSize s={16,16};
  
  [statusImage setSize:s];
  [_systemTray setImage:statusImage];
   
  [menu release];
}

- (void) updateTrack:(NSString *)title {
  [_systemTray setToolTip:title];
}

- (void)quitApp:(id)sender {
  [NSApp terminate: sender];
}

-(void)dealloc
{
  [_systemTray release];
}

@end
