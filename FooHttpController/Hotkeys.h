//
//  Hotkeys.h
//  FooHttpController
//
//  Created by Peroni Schoni on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

#define kHotkeyPlayLabel @"hotkeyPlayLabel"
#define kHotkeyPlayKeyCode @"hotkeyPlayKeyCode"
#define kHotkeyPlayModifiers @"hotkeyPlayModifiers"

#define kHotkeyPauseLabel @"hotkeyPauseLabel"
#define kHotkeyPauseKeyCode @"hotkeyPauseKeyCode"
#define kHotkeyPauseModifiers @"hotkeyPauseModifiers"

#define kHotkeyStopLabel @"hotkeyStopLabel"
#define kHotkeyStopKeyCode @"hotkeyStopKeyCode"
#define kHotkeyStopModifiers @"hotkeyStopModifiers"

#define kHotkeyPreviousLabel @"hotkeyPreviousLabel"
#define kHotkeyPreviousKeyCode @"hotkeyPreviousKeyCode"
#define kHotkeyPreviousModifiers @"hotkeyPreviousModifiers"

#define kHotkeyNextLabel @"hotkeyNextLabel"
#define kHotkeyNextKeyCode @"hotkeyNextKeyCode"
#define kHotkeyNextModifiers @"hotkeyNextModifiers"

#define kHotkeyShowFoobarLabel @"hotkeyShowFoobarLabel"
#define kHotkeyShowFoobarKeyCode @"hotkeyShowFoobarKeyCode"
#define kHotkeyShowFoobarModifiers @"hotkeyShowFoobarModifiers"

#define kHotkeyShowCurrentTrackLabel @"hotkeyShowCurrentTrackLabel"
#define kHotkeyShowCurrentTrackKeyCode @"hotkeyShowCurrentTrackKeyCode"
#define kHotkeyShowCurrentTrackModifiers @"hotkeyShowCurrentTrackModifiers"

@interface Hotkeys : NSObject {
  NSObject *_main;
  
  EventHotKeyRef _playHotKeyRef;
  EventHotKeyID _playHotKeyID;
  
  EventHotKeyRef _pauseHotKeyRef;
  EventHotKeyID _pauseHotKeyID;
  
  EventHotKeyRef _stopHotKeyRef;
  EventHotKeyID _stopHotKeyID;
  
  EventHotKeyRef _previousHotKeyRef;
  EventHotKeyID _previousHotKeyID;
  
  EventHotKeyRef _nextHotKeyRef;
  EventHotKeyID _nextHotKeyID;
  
  EventHotKeyRef _showFoobarHotKeyRef;
  EventHotKeyID _showFoobarHotKeyID;
  
  EventHotKeyRef _showCurrentTrackHotKeyRef;
  EventHotKeyID _showCurrentTrackHotKeyID;
  
}

- (void)awakeFromNibRegisterGlobalHotkeys:(NSObject *)main;
- (void)registerHotkeys;

@end
