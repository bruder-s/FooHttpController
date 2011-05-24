//
//  FooHttpControllerAppDelegate.h
//  FooHttpController
//
//  Created by Peroni Schoni on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SystemTray;
@class Hotkeys;
@class HotkeyTextView;

@interface FooHttpControllerAppDelegate : NSObject <NSApplicationDelegate> {
  
  //begin system tray
  @private SystemTray *_systemTray;
  //end system tray
  
  //begin hotkeys
  @private Hotkeys *_hotkeys;
  //end hotkeys
  
  IBOutlet NSTextField *lblLog;
  
  //allows mapping the text fields to an action 
  IBOutlet HotkeyTextView *hotkeyTextViewPlay;
  IBOutlet HotkeyTextView *hotkeyTextViewPause;
  IBOutlet HotkeyTextView *hotkeyTextViewStop;
  IBOutlet HotkeyTextView *hotkeyTextViewPrevious;
  IBOutlet HotkeyTextView *hotkeyTextViewNext;
  
  @private NSWindow *_mainWindow;
  
}

@property (assign) IBOutlet NSWindow *_mainWindow;


- (void)awakeFromNib;

+ (void)initialize;
- (void)dealloc;

- (IBAction)play:(id)sender;
- (IBAction)playOrPause:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)next:(id)sender;

- (void)setLog:(NSString *)message;

- (void)performAction:(NSString *)action;

- (void)reinitializeHotkeys;

@end
