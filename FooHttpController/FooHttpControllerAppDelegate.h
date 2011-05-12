//
//  FooHttpControllerAppDelegate.h
//  FooHttpController
//
//  Created by Peroni Schoni on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FooHttpControllerAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
