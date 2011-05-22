//
//  Hotkeys.h
//  FooHttpController
//
//  Created by Peroni Schoni on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHotkeyPlay @"hotkeyPlay"
#define kHotkeyPlayModifiers @"hotkeyPlayModifiers"
#define kHotkeyPause @"hotkeyPause"
#define kHotkeyPauseModifiers @"hotkeyPauseModifiers"
#define kHotkeyStop @"hotkeyStop"
#define kHotkeyStopModifiers @"hotkeyStopModifiers"
#define kHotkeyPrevious @"hotkeyPrevious"
#define kHotkeyPreviousModifiers @"hotkeyPreviousModifiers"
#define kHotkeyNext @"hotkeyNext"
#define kHotkeyNextModifiers @"hotkeyNextModifiers"

@interface Hotkeys : NSObject {
    
}

- (void)awakeFromNibRegisterGlobalHotkeys:(NSObject *)main;

@end
