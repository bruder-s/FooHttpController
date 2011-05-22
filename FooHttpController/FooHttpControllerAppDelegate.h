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

@interface FooHttpControllerAppDelegate : NSObject <NSApplicationDelegate> {
  
  //begin system tray
  @private SystemTray *_systemTray;
  //end system tray
  
  //begin hotkeys
  @private Hotkeys *_hotkeys;
  //end hotkeys
  
  IBOutlet NSTextField *lblLog;
    
  @private
    NSWindow *window;
  
}

@property (assign) IBOutlet NSWindow *window;

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

@end
