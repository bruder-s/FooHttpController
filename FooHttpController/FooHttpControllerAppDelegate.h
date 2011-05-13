//
//  FooHttpControllerAppDelegate.h
//  FooHttpController
//
//  Created by Peroni Schoni on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SystemTray.h"

@interface FooHttpControllerAppDelegate : NSObject <NSApplicationDelegate> {
  
  //begin system tray
  @private SystemTray *_mySystemTray;
  //end system tray
  
  IBOutlet NSTextField *lblLog;
    
  @private
    NSWindow *window;
  
}

@property (assign) IBOutlet NSWindow *window;

//begin global hotkeys
- (void)awakeFromNibRegisterGlobalHotkeys;
//end global hotkeys

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
