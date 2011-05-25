//
//  FooHttpControllerAppDelegate.m
//  FooHttpController
//
//  Created by Peroni Schoni on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FooHttpControllerAppDelegate.h"

#import <Carbon/Carbon.h>

#import "SystemTray.h"
#import "Hotkeys.h"
#import "HotkeyTextView.h"
#import "RegexKitLite.h"

#define kServerHostname @"serverHostname"
#define kServerPort @"serverPort"
#define kServerTemplate @"serverTemplate"

@implementation FooHttpControllerAppDelegate

@synthesize _mainWindow;

+ (void)initialize {
  
  //where are the usedefaults stored?
  //http://stackoverflow.com/questions/1676938/easy-way-to-see-saved-nsuserdefaults
  NSArray *path = NSSearchPathForDirectoriesInDomains(
    NSLibraryDirectory,
    NSUserDomainMask,
    YES
  );
  NSString *folder = [path objectAtIndex:0];
  NSLog(@"Your NSUserDefaults are stored in this folder: %@/Preferences", folder);
  
  //set default values
  [[NSUserDefaults standardUserDefaults] registerDefaults: 
     [NSDictionary dictionaryWithObjectsAndKeys:
      
      //Server
      
      [NSString stringWithFormat:@"%@", @"127.0.0.1"], kServerHostname, 
      [NSString stringWithFormat:@"%@", @"8888"], kServerPort, 
      [NSString stringWithFormat:@"%@", @"default"], kServerTemplate,
      
      //Hotkeys
      
      [NSString stringWithFormat:@"%@", @"OPTION+Y"], kHotkeyPlayLabel,
      [NSNumber numberWithInt:6], kHotkeyPlayKeyCode,
      [NSNumber numberWithInt:NSAlternateKeyMask], kHotkeyPlayModifiers,
      
      [NSString stringWithFormat:@"%@", @"Option+X"], kHotkeyPauseLabel,
      [NSNumber numberWithInt:7], kHotkeyPauseKeyCode,
      [NSNumber numberWithInt:NSAlternateKeyMask], kHotkeyPauseModifiers,
      
      [NSString stringWithFormat:@"%@", @"Option+C"], kHotkeyStopLabel,
      [NSNumber numberWithInt:8], kHotkeyStopKeyCode,
      [NSNumber numberWithInt:NSAlternateKeyMask], kHotkeyStopModifiers,
      
      [NSString stringWithFormat:@"%@", @"Option+V"], kHotkeyPreviousLabel,
      [NSNumber numberWithInt:9], kHotkeyPreviousKeyCode,
      [NSNumber numberWithInt:NSAlternateKeyMask], kHotkeyPreviousModifiers,
      
      [NSString stringWithFormat:@"%@", @"Option+B"], kHotkeyNextLabel,
      [NSNumber numberWithInt:11], kHotkeyNextKeyCode,
      [NSNumber numberWithInt:NSAlternateKeyMask], kHotkeyNextModifiers,
      
      nil
      
  ]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  
  //initialize SystemTray
  _systemTray=[SystemTray new];
  [_systemTray createMyTrayBar:self];
  
  [hotkeyTextViewPlay setUserDefaultsKey:kHotkeyPlayLabel:kHotkeyPlayKeyCode:kHotkeyPlayModifiers];
  [hotkeyTextViewPause setUserDefaultsKey:kHotkeyPauseLabel:kHotkeyPauseKeyCode:kHotkeyPauseModifiers];
  [hotkeyTextViewStop setUserDefaultsKey:kHotkeyStopLabel:kHotkeyStopKeyCode:kHotkeyStopModifiers];
  [hotkeyTextViewPrevious setUserDefaultsKey:kHotkeyPreviousLabel:kHotkeyPreviousKeyCode:kHotkeyPreviousModifiers];
  [hotkeyTextViewNext setUserDefaultsKey:kHotkeyNextLabel:kHotkeyNextKeyCode:kHotkeyNextModifiers];
  
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

- (NSString*)getUrl:(NSString*)cmd:(NSString*)param1 {
  
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  NSMutableString *url=[NSMutableString stringWithCapacity:256];
  [url appendString:@"http://"];
  [url appendString:[ud stringForKey:kServerHostname]];
  [url appendString:@":"];
  [url appendString:[ud stringForKey:kServerPort]];
  [url appendString:@"/"];
  [url appendString:[ud stringForKey:kServerTemplate]];
  [url appendString:@"/?cmd="];
  [url appendString:cmd];
  [url appendString:@"&param1="];
  [url appendString:param1];
  
  return [url autorelease];
  
}

- (void)refreshPlayingInfo {
  
  NSString *url=[self getUrl:@"RefreshPlayingInfo":@""];
  
	//NSLog(@"%@", url);
  
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
	
	NSURLResponse *response = nil;
	NSError *error = nil;
	
	NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	if (response) {
		
    //NSLog(@"Response: %@", response);
    
    //assume everything went ok
    
    if (data && [data length]>0) {
      
      NSString *textEncodingName=[response textEncodingName];
      NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(
        CFStringConvertIANACharSetNameToEncoding((CFStringRef)textEncodingName)
                                                                            );
      NSString* responseString = [[NSString alloc] initWithData:data encoding:encoding];
      //NSLog(@"%@", responseString);
      
      NSString *regexString = @"<span id=\"track_title\" class=\"track\">([^<]*)</span>";
      
      NSString *matchedString = [responseString stringByMatching:regexString capture:1L];
      
      NSString *title;
      
      if ([matchedString length]>0) {
        NSLog(@"%@", matchedString);
        title=[[NSString alloc] initWithString:matchedString];
      } else {
        title=[[NSString alloc] initWithString:@"FooHttpController"];
      }
      
      [_systemTray updateTrack:title];
      [title release];
      
      [responseString release];
    }
    
  } else {
    
    //NSLog(@"Error: %@", [error localizedDescription]);
  
  }
  
}

- (void)performAction:(NSString*)action
{
    
  //NSString *URLString;
	//NSStringEncoding encoding = NSUTF8StringEncoding;
	//URLString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)url, NULL, NULL, encoding);
    
  NSString *url=[self getUrl:action:@""];
    
	//NSLog(@"%@", url);
    
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
	
	NSURLResponse *response = nil;
	NSError *error = nil;
	
	NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	if (response) {
		
    //NSLog(@"Response: %@", response);
    
    //assume everything went ok
    
    if (data && [data length]>0) {
      
      //wait some time (250ms) before asking for the playing info
      [NSThread sleepForTimeInterval:0.25];
      //usleep(250000);
      
      [self refreshPlayingInfo];
      
    }
    
	} else {
    
		NSLog(@"Error: %@", [error localizedDescription]);
	
  }
  
}

- (void)awakeFromNib {
  
  //NSLog(@"awakeFromNib");
  
  //initialize hotkeys
  _hotkeys=[Hotkeys new];
  [_hotkeys awakeFromNibRegisterGlobalHotkeys:self];
  
}

- (void)reinitializeHotkeys {
  [_hotkeys registerHotkeys];
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
  * Dustin Bacharach - for Global Hotkey sample code
    http://dbachrach.com/blog/2005/11/program-global-hotkeys-in-cocoa-easily/
 
*/