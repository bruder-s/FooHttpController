//
//  FooHttpControllerAppDelegate.m
//  FooHttpController
//
//  Created by Peroni Schoni on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FooHttpControllerAppDelegate.h"

#define kServerHostname @"serverHostname"
#define kServerPort @"serverPort"
#define kServerTemplate @"serverTemplate"

@implementation FooHttpControllerAppDelegate

@synthesize window;

+ (void)initialize {
  [[NSUserDefaults standardUserDefaults] registerDefaults: 
     [NSDictionary dictionaryWithObjectsAndKeys:
      [NSString stringWithFormat:@"%@", @"127.0.0.1"], kServerHostname, 
      [NSString stringWithFormat:@"%@", @"8888"], kServerPort, 
      [NSString stringWithFormat:@"%@", @"default"], kServerTemplate, 
      nil
  ]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  
  //initialize SystemTray
  _systemTray=[SystemTray new];
  [_systemTray createMyTrayBar:self];
  
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
    
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  NSMutableString *url=[NSMutableString stringWithCapacity:256];
  [url appendString:@"http://"];
  [url appendString:[ud stringForKey:kServerHostname]];
  [url appendString:@":"];
  [url appendString:[ud stringForKey:kServerPort]];
  [url appendString:@"/"];
  [url appendString:[ud stringForKey:kServerTemplate]];
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

- (void)awakeFromNib {
  
  NSLog(@"awakeFromNib");
  
  //initialize hotkeys
  _hotkeys=[Hotkeys new];
  [_hotkeys awakeFromNibRegisterGlobalHotkeys:self];
  
}

-(void)dealloc
{
  
  //SystemTray deallocation
  [_systemTray dealloc];
  
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