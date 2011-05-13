//
//  FooHttpControllerAppDelegate.h
//  FooHttpController
//
//  Created by Peroni Schoni on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FooHttpControllerAppDelegate : NSObject <NSApplicationDelegate> {
  
  //begin system tray
  @private NSStatusItem *_systemTray;
  @private NSTimer *_timer;   
  @private NSDate *_startDate;
  @private NSTimeInterval _timeInterval;
  //end system tray
  
  IBOutlet NSTextField *lblLog;
    
  @private
    NSWindow *window;
  
}

@property (assign) IBOutlet NSWindow *window;

//begin system tray
- (void)createMyTrayBar;
- (void)deallocSystemTray;
- (void)quitApp:(id)sender;
//end system tray

//begin global hotkeys
- (void)awakeFromNibRegisterGlobalHotkeys;
//end global hotkeys

- (void)awakeFromNib;

- (void)dealloc;

- (IBAction)play:(id)sender;
- (IBAction)playOrPause:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)next:(id)sender;

- (void)setLog:(NSString *)message;

- (void)performAction:(NSString *)action;

@end
