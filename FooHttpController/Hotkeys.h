//
//  Hotkeys.h
//  FooHttpController
//
//  Created by Peroni Schoni on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface Hotkeys : NSObject {
    
}

- (void)awakeFromNibRegisterGlobalHotkeys:(NSObject *)main;

@end
