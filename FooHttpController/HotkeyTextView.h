//
//  HotkeyTextView.h
//  FooHttpController
//
//  Created by Peroni Schoni on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HotkeyTextView : NSTextView {
  
  @private NSString* _userDefaultsKeyLabel;
  @private NSString* _userDefaultsKeyKeyCode;
  @private NSString* _userDefaultsKeyModifiers;
  
  @private NSString* _key;
  @private unsigned int _keyCode;
  
  @private BOOL _ctrl;
  @private BOOL _shift;
  @private BOOL _option;
  
  @private BOOL _hasModifiers;
  
}

- (void)setUserDefaultsKey:(NSString *)userDefaultsKeyLabel:(NSString *)userDefaultsKeyKeyCode:(NSString *)userDefaultsKeyModifiers;

@end
