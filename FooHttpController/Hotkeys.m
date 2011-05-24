//
//  Hotkeys.m
//  FooHttpController
//
//  Created by Peroni Schoni on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Hotkeys.h"

#import <Carbon/Carbon.h>

#import "FooHttpControllerAppDelegate.h"

#define HOTKEY_PLAY     1
#define HOTKEY_PAUSE    2
#define HOTKEY_STOP     3
#define HOTKEY_PREVIOUS 4
#define HOTKEY_NEXT     5

@implementation Hotkeys

OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent,
                         void *userData)
{
  
  FooHttpControllerAppDelegate * mySelf = (FooHttpControllerAppDelegate *) userData;
  
  EventHotKeyID hkCom;
  GetEventParameter(theEvent,kEventParamDirectObject,typeEventHotKeyID,NULL,
                    sizeof(hkCom),NULL,&hkCom);
  int l = hkCom.id;
  
  switch (l) {
    case HOTKEY_PLAY:
      NSLog(@"htk_play");
      [mySelf play:(id)0];
      break;
    case HOTKEY_PAUSE:
      NSLog(@"htk_pause");
      [mySelf playOrPause:(id)0];
      break;
    case HOTKEY_STOP:
      NSLog(@"htk_stop");
      [mySelf stop:(id)0];
      break;
    case HOTKEY_PREVIOUS:
      NSLog(@"htk_previous");
      [mySelf previous:(id)0];
      break;
    case HOTKEY_NEXT:
      NSLog(@"htk_next");
      [mySelf next:(id)0];
      break;
  }
  return noErr;
}

//TODO: necessary?
- (UInt32)buildModifiersFromNSModifiers:(UInt32)nsModifiers {
  UInt32 modifiers=0;
  if ((nsModifiers & NSControlKeyMask) == NSControlKeyMask) {
    modifiers|=controlKey; 
  }
  if ((nsModifiers & NSAlternateKeyMask) == NSAlternateKeyMask) {
    modifiers|=optionKey; 
  }
  if ((nsModifiers & NSShiftKeyMask) == NSShiftKeyMask) {
    modifiers|=shiftKey; 
  }
  return modifiers;
}

- (void)registerHotkeys {
    
  if (_playHotKeyRef!=nil) {
    UnregisterEventHotKey(_playHotKeyRef);
  }
  
  RegisterEventHotKey(
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPlayKeyCode],
    [self buildModifiersFromNSModifiers:(UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPlayModifiers]],
    _playHotKeyID,
    GetApplicationEventTarget(),
    0,
    &_playHotKeyRef
  );
  
  if (_pauseHotKeyRef!=nil) {
    UnregisterEventHotKey(_pauseHotKeyRef);
  }
  
  RegisterEventHotKey(
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPauseKeyCode],
    [self buildModifiersFromNSModifiers:(UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPauseModifiers]],
    _pauseHotKeyID,
    GetApplicationEventTarget(), 
    0,
    &_pauseHotKeyRef
  );
  
  if (_stopHotKeyRef!=nil) {
    UnregisterEventHotKey(_stopHotKeyRef);
  }
  
  RegisterEventHotKey(
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyStopKeyCode],
    [self buildModifiersFromNSModifiers:(UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyStopModifiers]],
    _stopHotKeyID,
    GetApplicationEventTarget(),
    0,
    &_stopHotKeyRef
  );
  
  if (_previousHotKeyRef!=nil) {
    UnregisterEventHotKey(_previousHotKeyRef);
  }
  
  RegisterEventHotKey(
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPreviousKeyCode],
    [self buildModifiersFromNSModifiers:(UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPreviousModifiers]],
    _previousHotKeyID,
    GetApplicationEventTarget(),
    0,
    &_previousHotKeyRef
  );
  
  if (_nextHotKeyRef!=nil) {
    UnregisterEventHotKey(_nextHotKeyRef);
  }
  
  RegisterEventHotKey(
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyNextKeyCode],
    [self buildModifiersFromNSModifiers:(UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyNextModifiers]],
    _nextHotKeyID,
    GetApplicationEventTarget(),
    0,
    &_nextHotKeyRef
  );
  
}

- (void)awakeFromNibRegisterGlobalHotkeys:(NSObject *)main {
  
  //Prepare
  
  _main=main;
  
  _playHotKeyRef=nil;
  _playHotKeyID.signature='htk1';
  _playHotKeyID.id=HOTKEY_PLAY;
  
  _pauseHotKeyRef=nil;
  _pauseHotKeyID.signature='htk2';
  _pauseHotKeyID.id=HOTKEY_PAUSE;
  
  _stopHotKeyRef=nil;
  _stopHotKeyID.signature='htk3';
  _stopHotKeyID.id=HOTKEY_STOP;
  
  _previousHotKeyRef=nil;
  _previousHotKeyID.signature='htk4';
  _previousHotKeyID.id=HOTKEY_PREVIOUS;
  
  _nextHotKeyRef=nil;
  _nextHotKeyID.signature='htk5';
  _nextHotKeyID.id=HOTKEY_NEXT;
  
  EventTypeSpec eventType;
  eventType.eventClass=kEventClassKeyboard;
  eventType.eventKind=kEventHotKeyPressed;
  InstallApplicationEventHandler(&MyHotKeyHandler,1,&eventType,(void *)_main,NULL);
  
  //Register
  
  [self registerHotkeys];
  
  /*
  
  //Register the Hotkeys
  EventHotKeyRef gMyHotKeyRef;
  EventHotKeyID gMyHotKeyID;
  EventTypeSpec eventType;
  eventType.eventClass=kEventClassKeyboard;
  eventType.eventKind=kEventHotKeyPressed;
  InstallApplicationEventHandler(&MyHotKeyHandler,1,&eventType,(void *)main,NULL);
  gMyHotKeyID.signature='htk1';
  gMyHotKeyID.id=HOTKEY_PLAY;
  
  RegisterEventHotKey(
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPlayKeyCode],
    [self buildModifiersFromNSModifiers:(UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPlayModifiers]],
    gMyHotKeyID,
    GetApplicationEventTarget(),
    0,
    &gMyHotKeyRef
  );
  
  gMyHotKeyID.signature='htk2';
  gMyHotKeyID.id=HOTKEY_PAUSE;
  UInt32 modifiers=(UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPauseModifiers];
  
  RegisterEventHotKey(
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPauseKeyCode],
    [self buildModifiersFromNSModifiers:(UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPauseModifiers]],
    gMyHotKeyID,
    GetApplicationEventTarget(), 
    0,
    &gMyHotKeyRef
  );
  
  gMyHotKeyID.signature='htk3';
  gMyHotKeyID.id=HOTKEY_STOP;
  RegisterEventHotKey(
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyStopKeyCode],
    [self buildModifiersFromNSModifiers:(UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyStopModifiers]],
    gMyHotKeyID,
    GetApplicationEventTarget(),
    0,
    &gMyHotKeyRef
  );
  
  gMyHotKeyID.signature='htk4';
  gMyHotKeyID.id=HOTKEY_PREVIOUS;
  RegisterEventHotKey(
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPreviousKeyCode],
    [self buildModifiersFromNSModifiers:(UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPreviousModifiers]],
    gMyHotKeyID,
    GetApplicationEventTarget(),
    0,
    &gMyHotKeyRef
  );
  
  if (gMyHotKeyRef!=nil) {
    
  }
  
  gMyHotKeyID.signature='htk5';
  gMyHotKeyID.id=HOTKEY_NEXT;
  RegisterEventHotKey(
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyNextKeyCode],
    [self buildModifiersFromNSModifiers:(UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyNextModifiers]],
    gMyHotKeyID,
    GetApplicationEventTarget(),
    0,
    &gMyHotKeyRef
  );
   
   */
  
}

@end
