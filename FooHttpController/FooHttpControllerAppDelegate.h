//
//  FooHttpControllerAppDelegate.h
//  FooHttpController
//
//  Created by Peroni Schoni on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FooHttpControllerAppDelegate : NSObject <NSApplicationDelegate> {

IBOutlet NSTextField *lblLog;
    
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)play:(id)sender;
- (IBAction)pauseOrPlay:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)next:(id)sender;

- (void)setLog:(NSString *)message;

- (void)performAction:(NSString *)action;

@end
