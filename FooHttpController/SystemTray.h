//
//  SystemTray.h
//  FooHttpController
//
//  Created by Peroni Schoni on 5/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SystemTray : NSObject {

  @private NSStatusItem *_systemTray;
  @private NSImage *_statusImage;
  @private NSImage *_alternateStatusImage;
  
  @private NSTimer *_reloadPlayingInfoTimer;
  
  @private int _animationStep;
  
}

- (void) dealloc;
- (void) createMyTrayBar:(NSObject*)receiver;
- (void) updateTrack:(NSString *)title;
- (void) animateStatusIcon;
- (void) quitApp:(id)sender;

@end
