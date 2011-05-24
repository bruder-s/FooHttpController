//
//  HotkeyTextView.m
//  FooHttpController
//
//  Created by Peroni Schoni on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HotkeyTextView.h"
#import "Hotkeys.h"

@implementation HotkeyTextView

- (id)init {
  self = [super init];
  if (self) {
    _userDefaultsKeyLabel=[@"_unknownLabel" mutableCopy];
    _userDefaultsKeyKeyCode=[@"_unknownKeyCode" mutableCopy];
    _userDefaultsKeyModifiers=[@"_unknownModifiers" mutableCopy];
    _key=[@"" mutableCopy];
    _keyCode=0;
    _ctrl=NO;
    _option=NO;
    _shift=NO;
    _hasModifiers=NO;
  }
  return (self);
}

- (void)updateHotkey:(BOOL)keyDown {
  
  NSMutableString *text=[NSMutableString stringWithCapacity:20];
  
  _hasModifiers=NO;
  
  if (_ctrl) {
    if (_hasModifiers) {
      [text appendString:@"+"];
    }
    [text appendString:@"CTRL"];
    _hasModifiers=YES;
  }
  if (_option) {
    if (_hasModifiers) {
      [text appendString:@"+"];
    }
    [text appendString:@"OPTION"];
    _hasModifiers=YES;
  }
  if (_shift) {
    if (_hasModifiers) {
      [text appendString:@"+"];
    }
    [text appendString:@"SHIFT"];
    _hasModifiers=YES;
  }
  
  if (_hasModifiers && 1==[_key length]) {
    [text appendString:@"+"];
    [text appendString:[_key uppercaseString]];
    if (keyDown) {
      [[NSUserDefaults standardUserDefaults] setValue:text forKey:_userDefaultsKeyLabel];
      //[[NSUserDefaults standardUserDefaults] setValue:_key forKey:_userDefaultsKeyKey];
      [[NSUserDefaults standardUserDefaults] setInteger:_keyCode forKey:_userDefaultsKeyKeyCode];
      unsigned int modifiers=(_ctrl ? NSControlKeyMask : 0) | (_option ? NSAlternateKeyMask : 0) | (_shift ? NSShiftKeyMask : 0);
      [[NSUserDefaults standardUserDefaults] setInteger: modifiers forKey:_userDefaultsKeyModifiers];
    }
  }
  
}

- (void)setUserDefaultsKey:(NSString *)userDefaultsKeyLabel:(NSString *)userDefaultsKeyKeyCode:(NSString *)userDefaultsKeyModifiers {
  
  _userDefaultsKeyLabel=[userDefaultsKeyLabel mutableCopy];
  _userDefaultsKeyKeyCode=[userDefaultsKeyKeyCode mutableCopy];
  _userDefaultsKeyModifiers=[userDefaultsKeyModifiers mutableCopy];
  
  //_key=[[[NSUserDefaults standardUserDefaults] valueForKey:_userDefaultsKeyKey] mutableCopy];
  _key=[@"" mutableCopy];
  _keyCode=(unsigned int)[[NSUserDefaults standardUserDefaults] integerForKey:_userDefaultsKeyKeyCode];

  unsigned int modifiers=(unsigned int)[[NSUserDefaults standardUserDefaults]integerForKey:_userDefaultsKeyModifiers];
  _ctrl=((modifiers & NSControlKeyMask) == NSControlKeyMask);
  _option=((modifiers & NSAlternateKeyMask) == NSAlternateKeyMask);
  _shift=((modifiers & NSShiftKeyMask) == NSShiftKeyMask);
  
  _hasModifiers=NO;
  
  NSLog(@"Setting _userDefaultsKeyLabel '%@'", _userDefaultsKeyLabel);
  NSLog(@"Setting _userDefaultsKeyKeyCode '%@'", _userDefaultsKeyKeyCode);
  NSLog(@"Setting _userDefaultsKeyModifiers '%@'", _userDefaultsKeyModifiers);

}

- (void)keyDown:(NSEvent *)pEvent
{
  //NSLog(@"hotkeyKeyDown");
  
  if (_hasModifiers) {
    
    _keyCode=[pEvent keyCode];
    _key = [[pEvent charactersIgnoringModifiers] mutableCopy];
    
    if (1==[_key length]) {
      
      NSLog(@"Key '%@' #%d", _key, _keyCode);
      
      /*
      //TODO: what are valid characters here?
      NSMutableString *text=[NSMutableString stringWithCapacity:20];
      [text appendString:[[NSUserDefaults standardUserDefaults] valueForKey:_userDefaultsKey]];
      [text appendString:@"+"];
      [text appendString:[characters uppercaseString]];
      [[NSUserDefaults standardUserDefaults] setValue:text forKey:_userDefaultsKey];
      _lastValidHotkey=[text mutableCopy];
      
      /*switch ([characters characterAtIndex:0]) {
        case NSUpArrowFunctionKey:
          NSLog(@"Key UP");
          break;
      }*/
      
      [self updateHotkey:YES];
      
    } else {
      
      _key=[@"" mutableCopy];
      _keyCode=0;
      
    }
  }
  
  //[super keyDown: pEvent];
}

- (void)flagsChanged:(NSEvent *)pEvent {
  
  //NSLog(@"hotkeyFlagsChanged");
  
  //NSLog(@"Flags '%@'", pEvent);
 
  NSUInteger flags=[pEvent modifierFlags];
  //NSLog(@"%lu", flags);
  
  _ctrl=((flags & NSControlKeyMask) == NSControlKeyMask);
  _option=((flags & NSAlternateKeyMask) == NSAlternateKeyMask);
  _shift=((flags & NSShiftKeyMask) == NSShiftKeyMask);
  
  [self updateHotkey:NO];
  
  //[super keyDown: pEvent];
  
}

@end
