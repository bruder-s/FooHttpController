//
//  NotificationWindow.h
//  FooHttpController
//
//  Created by Peroni Schoni on 5/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NotificationWindow : NSWindow {
    
  IBOutlet NSTextField *_lblTrack;
  @private NSTimer *_fadeoutTimer;
  
}

-(void)showNotification;

@end
