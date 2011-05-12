//
//  FooHttpControllerAppDelegate.m
//  FooHttpController
//
//  Created by Peroni Schoni on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FooHttpControllerAppDelegate.h"
//begin global hotkeys
#import <Carbon/Carbon.h>
//end global hotkeys

#define HOTKEY_PLAY     1
#define HOTKEY_PAUSE    2
#define HOTKEY_STOP     3
#define HOTKEY_PREVIOUS 4
#define HOTKEY_NEXT     5

@implementation FooHttpControllerAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  //initialize your NSStatusBar
  [self createMyTrayBar];
  [self setLog:@"Initialized"];
}

- (void)setLog:(NSString *)message {
    NSLog (@"%s", [message UTF8String]);
    NSMutableString *log=[NSMutableString stringWithCapacity:1024];
    [log appendString:message];
    [log appendString:@"\n"];
    [log appendString:[lblLog stringValue]];
    [lblLog setStringValue:log];
}

- (IBAction)play:(id)sender
{
    [self setLog:@"Received play event"];
    [self performAction:@"Start"];
}

- (IBAction)playOrPause:(id)sender
{
    [self setLog:@"Received playOrPause event"];
    [self performAction:@"PlayOrPause"];

}

- (IBAction)stop:(id)sender
{
    [self setLog:@"Received stop event"];
    [self performAction:@"Stop"];

}

- (IBAction)next:(id)sender
{
    [self setLog:@"Received next event"];
    [self performAction:@"StartNext"];

}

- (IBAction)previous:(id)sender
{
    [self setLog:@"Received previous event"];
    [self performAction:@"StartPrevious"];

}

- (void)performAction:(NSString*)action
{
    
    //NSString *URLString;
	//NSStringEncoding encoding = NSUTF8StringEncoding;
	//URLString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)url, NULL, NULL, encoding);
    
    NSString *hostname=@"127.0.0.1";
    NSString *port=@"8888";
    NSString *template=@"default";
    
    NSMutableString *url=[NSMutableString stringWithCapacity:256];
    [url appendString:@"http://"];
    [url appendString:hostname];
    [url appendString:@":"];
    [url appendString:port];
    [url appendString:@"/"];
    [url appendString:template];
    [url appendString:@"/?cmd="];
    [url appendString:action];
    [url appendString:@"&param1="];
    
	NSLog(@"%@", url);
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
	
	NSURLResponse *response = nil;
	NSError *error = nil;
	
	[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	if(response){
		NSLog(@"Response: %@", response);
	}
	else{
		NSLog(@"Error: %@", [error localizedDescription]);
	}
  
}
  
//begin system tray

- (void) createMyTrayBar  {
  NSZone *menuZone = [NSMenu menuZone];
  NSMenu *menu = [[NSMenu allocWithZone:menuZone] init];
  NSMenuItem *menuItem;
  
  menuItem = [menu addItemWithTitle:@"Start" action:@selector(play:) keyEquivalent:@""];
  [menuItem setTarget:self];
  
  menuItem = [menu addItemWithTitle:@"Pause" action:@selector(playOrPause:) keyEquivalent:@""];
  [menuItem setTarget:self];
  
  menuItem = [menu addItemWithTitle:@"Stop" action:@selector(stop:) keyEquivalent:@""];
  [menuItem setTarget:self];
  
  menuItem = [menu addItemWithTitle:@"Previous" action:@selector(previous:) keyEquivalent:@""];
  [menuItem setTarget:self];
  
  menuItem = [menu addItemWithTitle:@"Next" action:@selector(next:) keyEquivalent:@""];
  [menuItem setTarget:self];
  
  [menu addItem:[NSMenuItem separatorItem]];
  
  menuItem = [menu addItemWithTitle:@"Quit" action:@selector(quitApp:) keyEquivalent:@""];
  [menuItem setTarget:self];
  
  _systemTray = [[[NSStatusBar systemStatusBar]
                  statusItemWithLength:NSVariableStatusItemLength] retain];
  
  [_systemTray setMenu:menu];
  [_systemTray setHighlightMode:YES];
  [_systemTray setToolTip:@"FooHttpController"];
  [_systemTray setTitle:@"F"];
  
  [menu release];
}

- (void)quitApp:(id)sender {
  [NSApp terminate: sender];
}
-(void)deallocSystemTray
{
  [_systemTray release];
}
//end system tray

- (void)awakeFromNib {
  [self awakeFromNibRegisterGlobalHotkeys];
}

//begin global hotkeys
OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent,
                         void *userData)
{
  
  FooHttpControllerAppDelegate * mySelf = (FooHttpControllerAppDelegate *) userData;
  
  EventHotKeyID hkCom;
  GetEventParameter(theEvent,kEventParamDirectObject,typeEventHotKeyID,NULL,
                    sizeof(hkCom),NULL,&hkCom);
  int l = hkCom.id;
  
  switch (l) {
    case HOTKEY_PLAY:
      NSLog(@"htk_play");
      [mySelf play:(id)0];
      break;
    case HOTKEY_PAUSE:
      NSLog(@"htk_pause");
      [mySelf playOrPause:(id)0];
      break;
    case HOTKEY_STOP:
      NSLog(@"htk_stop");
      [mySelf stop:(id)0];
      break;
    case HOTKEY_PREVIOUS:
      NSLog(@"htk_previous");
      [mySelf previous:(id)0];
      break;
    case HOTKEY_NEXT:
      NSLog(@"htk_next");
      [mySelf next:(id)0];
      break;
  }
  return noErr;
}
- (void)awakeFromNibRegisterGlobalHotkeys {
  NSLog(@"awakeFromNib");
  //Register the Hotkeys
  EventHotKeyRef gMyHotKeyRef;
  EventHotKeyID gMyHotKeyID;
  EventTypeSpec eventType;
  eventType.eventClass=kEventClassKeyboard;
  eventType.eventKind=kEventHotKeyPressed;
  InstallApplicationEventHandler(&MyHotKeyHandler,1,&eventType,(void *)self,NULL);
  gMyHotKeyID.signature='htk1';
  gMyHotKeyID.id=HOTKEY_PLAY;
  RegisterEventHotKey(6, optionKey, gMyHotKeyID,
                      GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  gMyHotKeyID.signature='htk2';
  gMyHotKeyID.id=HOTKEY_PAUSE;
  RegisterEventHotKey(7, optionKey, gMyHotKeyID,
                      GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  gMyHotKeyID.signature='htk3';
  gMyHotKeyID.id=HOTKEY_STOP;
  RegisterEventHotKey(8, optionKey, gMyHotKeyID,
                      GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  gMyHotKeyID.signature='htk4';
  gMyHotKeyID.id=HOTKEY_PREVIOUS;
  RegisterEventHotKey(9, optionKey, gMyHotKeyID,
                      GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  gMyHotKeyID.signature='htk5';
  gMyHotKeyID.id=HOTKEY_NEXT;
  RegisterEventHotKey(11, optionKey, gMyHotKeyID,
                      GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
}


//end global hotkeys

-(void)dealloc
{
  [self deallocSystemTray];
  [super dealloc];
}

@end

/*
 
 Credits and thanks:
 
  * rzepus - for SystemTray sample code
    http://blog.rzepus.pl/index.php/cocoa/traybar-status-bar-in-cocoa-nsstatusbar/
  * dbacharach - for Global Hotkey sample code
    http://dbachrach.com/blog/2005/11/program-global-hotkeys-in-cocoa-easily/
 
*/