//
//  FooHttpControllerAppDelegate.m
//  FooHttpController
//
//  Created by Peroni Schoni on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FooHttpControllerAppDelegate.h"

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

- (IBAction)pauseOrPlay:(id)sender
{
    [self setLog:@"Received playOrPause event"];
    [self performAction:@"Start"];

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
- (void)startTimer:(id)sender {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];

    [_timer fire];
  }
  
- (void)stopTimer:(id)sender {
    _timeInterval = [_startDate timeIntervalSinceNow];
    [_timer invalidate];
    [_timer release];
  }
  
- (IBAction)updateTime:(id)sender {
    
    //refresh time count in NSStatusBar
    //[_systemTray setTitle:[NSString stringWithFormat:@"%d:%d:%d", hours, minutes, seconds]];
    [_systemTray setTitle:[NSString stringWithFormat:@"%d:%d:%d", 2, 3, 4]];
  }

- (void) createMyTrayBar  {
  NSZone *menuZone = [NSMenu menuZone];
  NSMenu *menu = [[NSMenu allocWithZone:menuZone] init];
  NSMenuItem *menuItem;
  
  menuItem = [menu addItemWithTitle:@"Start" action:@selector(startTimer:) keyEquivalent:@""];
  [menuItem setTarget:self];
  
  menuItem = [menu addItemWithTitle:@"Stop" action:@selector(stopTimer:) keyEquivalent:@""];
  [menuItem setTarget:self];
  
  [menu addItem:[NSMenuItem separatorItem]];
  
  menuItem = [menu addItemWithTitle:@"Quit" action:@selector(quitApp:) keyEquivalent:@""];
  [menuItem setTarget:self];
  
  _systemTray = [[[NSStatusBar systemStatusBar]
                  statusItemWithLength:NSVariableStatusItemLength] retain];
  
  [_systemTray setMenu:menu];
  [_systemTray setHighlightMode:YES];
  [_systemTray setToolTip:@"Work time counter"];
  [_systemTray setTitle:@"☁☁"];
  
  [menu release];
}
-(void)dealloc
{
  if (_timer != NULL) {
    [_timer release];
  }
  
  [_systemTray release];
  [super dealloc];
}
- (void)quitApp:(id)sender {
  [NSApp terminate: sender];
}
//end system tray
    

@end

/*
 
 Credits and thanks:
 
  * rzepus - for SystemTray sample code
    http://blog.rzepus.pl/index.php/cocoa/traybar-status-bar-in-cocoa-nsstatusbar/
 
*/