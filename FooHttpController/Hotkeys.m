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

- (void)awakeFromNibRegisterGlobalHotkeys:(NSObject *)main {
  
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
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPlay],
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPlayModifiers],
    gMyHotKeyID,
    GetApplicationEventTarget(),
    0,
    &gMyHotKeyRef
  );
  
  gMyHotKeyID.signature='htk2';
  gMyHotKeyID.id=HOTKEY_PAUSE;
  RegisterEventHotKey(
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPause],
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPauseModifiers],
    gMyHotKeyID,
    GetApplicationEventTarget(), 
    0,
    &gMyHotKeyRef
  );
  
  gMyHotKeyID.signature='htk3';
  gMyHotKeyID.id=HOTKEY_STOP;
  RegisterEventHotKey(
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyStop],
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyStopModifiers],
    gMyHotKeyID,
    GetApplicationEventTarget(),
    0,
    &gMyHotKeyRef
  );
  
  gMyHotKeyID.signature='htk4';
  gMyHotKeyID.id=HOTKEY_PREVIOUS;
  RegisterEventHotKey(
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPrevious],
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyPreviousModifiers],
    gMyHotKeyID,
    GetApplicationEventTarget(),
    0,
    &gMyHotKeyRef
  );
  
  gMyHotKeyID.signature='htk5';
  gMyHotKeyID.id=HOTKEY_NEXT;
  RegisterEventHotKey(
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyNext],
    (UInt32)[[NSUserDefaults standardUserDefaults] integerForKey:kHotkeyNextModifiers],
    gMyHotKeyID,
    GetApplicationEventTarget(),
    0,
    &gMyHotKeyRef
  );
  
}

@end
