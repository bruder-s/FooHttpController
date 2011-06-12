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
  
  _reloadPlayingInfoTimer=nil;
  _animationStep=-1;
  
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
    
  menuItem = [menu addItemWithTitle:@"Show Foobar" action:@selector(showFoobar:) keyEquivalent:@""];
  [menuItem setTarget:receiver];
    
  menuItem = [menu addItemWithTitle:@"Show current track" action:@selector(showCurrentTrack:) keyEquivalent:@""];
  [menuItem setTarget:receiver];
  
  [menu addItem:[NSMenuItem separatorItem]];
  
  menuItem = [menu addItemWithTitle:@"Preferences" action:@selector(showPreferencesWindow:) keyEquivalent:@""];
  [menuItem setTarget:receiver];
    
  [menu addItem:[NSMenuItem separatorItem]];
  
  menuItem = [menu addItemWithTitle:@"Quit" action:@selector(quitApp:) keyEquivalent:@""];
  [menuItem setTarget:self];
    
  
  
  _systemTray = [[[NSStatusBar systemStatusBar]
                  statusItemWithLength:NSVariableStatusItemLength] retain]; //NSSquareStatusItemLength
  
  [_systemTray setMenu:menu];
  [_systemTray setHighlightMode:YES];
  [_systemTray setToolTip:@"FooHttpController"];
  
  //[_systemTray setTitle:@"F"];

  //set the icon
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *iconPath=[bundle pathForResource:@"status_item" ofType:@"png"];
  _statusImage=[[NSImage alloc] initWithContentsOfFile:iconPath];
  NSSize s={16,16};
  [_statusImage setSize:s];
  [_systemTray setImage:_statusImage];
  
  //set the highlight icon
  iconPath=[bundle pathForResource:@"status_item_highlight" ofType:@"png"];
  _alternateStatusImage=[[NSImage alloc] initWithContentsOfFile:iconPath];
  [_statusImage setSize:s];
  [_systemTray setAlternateImage:_alternateStatusImage];
   
  [menu release];
  
}

- (void)createAnimateStatusIconTimer {
  
  //NSLog(@"%d", _animationStep);
  
  [NSTimer
    scheduledTimerWithTimeInterval:0.05
    target:self
    selector:@selector(fireAnimateStatusIconTimer:)
    userInfo:nil
    repeats:NO
  ];
  
}

- (void)fireAnimateStatusIconTimer:(NSTimer *)timer {
  
  //NSLog(@"TIMER %d %d", intNumber, intNumber % 2);
  
  if (_animationStep >= 0) {
    if (_animationStep % 2==0) {
      [_systemTray setImage:_statusImage];
    } else {
      [_systemTray setImage:_alternateStatusImage];
    }
    [self createAnimateStatusIconTimer];
    _animationStep--;
  }
  
  [timer invalidate];
  timer = nil;
    
}

- (void) updateTrack:(NSString *)title {
  [_systemTray setToolTip:title];
}

- (void) animateStatusIcon {
  if (_animationStep==-1) {
    _animationStep=4;
    [self createAnimateStatusIconTimer];
  }
}

- (void)quitApp:(id)sender {
  [NSApp terminate: sender];
}

-(void)dealloc
{
  [_systemTray release];
  [_statusImage release];
  [_alternateStatusImage release];
  [super dealloc];
}

@end
