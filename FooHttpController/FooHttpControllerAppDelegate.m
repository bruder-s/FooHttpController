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
#import "NotificationWindow.h"

#define kServerHostname @"serverHostname"
#define kServerPort @"serverPort"
#define kServerTemplate @"serverTemplate"

@implementation FooHttpControllerAppDelegate

@synthesize _mainWindow;

+ (void)initialize {
  
  //where are the userdefaults stored?
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
      
      [NSString stringWithFormat:@"%@", @"OPTION+X"], kHotkeyPauseLabel,
      [NSNumber numberWithInt:7], kHotkeyPauseKeyCode,
      [NSNumber numberWithInt:NSAlternateKeyMask], kHotkeyPauseModifiers,
      
      [NSString stringWithFormat:@"%@", @"OPTION+C"], kHotkeyStopLabel,
      [NSNumber numberWithInt:8], kHotkeyStopKeyCode,
      [NSNumber numberWithInt:NSAlternateKeyMask], kHotkeyStopModifiers,
      
      [NSString stringWithFormat:@"%@", @"OPTION+V"], kHotkeyPreviousLabel,
      [NSNumber numberWithInt:9], kHotkeyPreviousKeyCode,
      [NSNumber numberWithInt:NSAlternateKeyMask], kHotkeyPreviousModifiers,
      
      [NSString stringWithFormat:@"%@", @"OPTION+B"], kHotkeyNextLabel,
      [NSNumber numberWithInt:11], kHotkeyNextKeyCode,
      [NSNumber numberWithInt:NSAlternateKeyMask], kHotkeyNextModifiers,
      
      nil
      
  ]];
  
}

- (BOOL) bringWindowWithNameToFront:(NSString *) windowName
{
  // Try to find a window named "windowName", and if found,
  // bring it to the front
  // Stephan Burlot 4/3/08
  
  CFArrayRef            windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
  ProcessSerialNumber   myPSN = {kNoProcess, kNoProcess};
  BOOL                  returnValue = FALSE;
  
  for (NSMutableDictionary *entry in (NSArray *)windowList) {
    NSString *currentWindow = [entry objectForKey:(id)kCGWindowName];
    NSLog(@"%@", currentWindow);
    if ((currentWindow != NULL) && ([currentWindow isEqualToString:windowName]))
    {
      NSString *applicationName = [entry objectForKey:(id)kCGWindowOwnerName];
      int pid = [[entry objectForKey:(id)kCGWindowOwnerPID] intValue];
      GetProcessForPID(pid, &myPSN);
      
      NSString *script= [NSString stringWithFormat:@"tell application \"System Events\" to tell process \"%@\" to perform action \"AXRaise\" of window \"%@\"\ntell application \"%@\" to activate\n", applicationName, windowName, applicationName];
      NSAppleScript *as = [[NSAppleScript alloc] initWithSource:script];
      [as compileAndReturnError:NULL];
      [as executeAndReturnError:NULL];  // Bring it on!
      [as release];
      returnValue = TRUE;
    }
  }
  
  CFRelease(windowList);
  return returnValue;
}

-(void)fireTrackChangeDetectionTimer:(NSTimer *)timer {
  
  //NSLog(@"%@", @"fireTrackChangeDetectionTimer");
  
  NSString *windowName=nil;
  NSString *track=nil;
  BOOL foundSomething=NO;
  CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
  for (NSMutableDictionary* entry in (NSArray*)windowList) 
  {
    //NSString* ownerName = [entry objectForKey:(id)kCGWindowOwnerName];
    //NSInteger ownerPID = [[entry objectForKey:(id)kCGWindowOwnerPID] integerValue];
    if (!foundSomething) {
      windowName = [entry objectForKey:(id)kCGWindowName];
      if (windowName!=nil && [windowName length]>0) {
        
        //NSLog(@"%@", windowName);
        
        NSString *matchedStringStopped = [windowName stringByMatching:_regexStringFoobar2000Stopped capture:0L];
        NSString *matchedStringWithTrack = [windowName stringByMatching:_regexStringFoobar2000WithTrack capture:1L];
        
        if ([matchedStringStopped length]>0) {
          
          //ignore
          
          //NSLog(@"%@", @"[Stopped]");
          //track=[@"[Stopped]" mutableCopy];
          //foundSomething=YES;
          
        } else if ([matchedStringWithTrack length]>0) {
          
          //NSLog(@"Track %@", matchedStringWithTrack);
          track=[matchedStringWithTrack mutableCopy];
          foundSomething=YES;
          
        } else {
          
          //NSLog(@"%@", @"not matched");
          
        }
        
      }
    }
    //NSLog(@"%@:%@:%ld", ownerName, windowName, ownerPID);
  }
  CFRelease(windowList);
  
  if (track!=nil) {
    if (_currentPlayingTrack==nil) {
      //first time init
      _currentPlayingTrack=[track mutableCopy];
    } else if ([_currentPlayingTrack isEqualToString:track]) {
      //nothing changed - ignore
    } else {
      //track changed (or stopped)
      [_currentPlayingTrack release];
      _currentPlayingTrack=[track mutableCopy];
      NSLog(@"Track change detected: '%@'", track);
      [_lblTrack setStringValue:[track mutableCopy]];
      [_lblTrackBackground setStringValue:[track mutableCopy]];
      [_notificationWindow showNotification];
    }
    [track release];
  }
  
}

-(void)initializeTrackChangeDetection {
  
  _currentPlayingTrack=nil;
  _regexStringFoobar2000Stopped = @"^foobar2000 v\\d+(.\\d+)*$";
  _regexStringFoobar2000WithTrack = @"^(.*?)\\s*\\[foobar2000 v\\d+(.\\d+)*\\]$";
  [NSTimer
    scheduledTimerWithTimeInterval:1.0
    target:self
    selector:@selector(fireTrackChangeDetectionTimer:)
    userInfo:nil
    repeats:YES
  ];
  
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
  
  [self initializeTrackChangeDetection];
  
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

- (IBAction)showCurrentTrack:(id)sender
{
  //NSLog(@"showCurrentTrack");
  if (![[_lblTrack stringValue] isEqualTo:@"Label"]) {
    [_notificationWindow showNotification];
  }
}

- (IBAction)showFoobar:(id)sender
{
  NSLog(@"showFoobar");
  NSString *windowName=nil;
  BOOL foundSomething=NO;
  CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
  for (NSMutableDictionary* entry in (NSArray*)windowList) 
  {
    if (!foundSomething) {
      windowName = [entry objectForKey:(id)kCGWindowName];
      //pid_t ownerPID_t=[entry objectForKey:(id)kCGWindowOwnerPID];
      NSInteger ownerPID = [[entry objectForKey:(id)kCGWindowOwnerPID] integerValue];
      pid_t ownerPID_t=(pid_t)ownerPID;
      
      if (windowName!=nil && [windowName length]>0) {
        
        NSString *matchedStringStopped = [windowName stringByMatching:_regexStringFoobar2000Stopped capture:0L];
        NSString *matchedStringWithTrack = [windowName stringByMatching:_regexStringFoobar2000WithTrack capture:1L];
        
        if (
          [matchedStringStopped length]>0 ||
          [matchedStringWithTrack length]>0
        ) {
          NSLog(@"showFoobar owner pid %ld", ownerPID);
          //NSLog(@"showFoobar pid %ld", pID);
          NSRunningApplication *runApp =  [NSRunningApplication runningApplicationWithProcessIdentifier: ownerPID_t];
          NSLog(@"showFoobar app %ld", (void*)runApp);
          [runApp activateWithOptions: NSApplicationActivateAllWindows];
        }
      }
    }
    //NSLog(@"%@:%@:%ld", ownerName, windowName, ownerPID);
  }
  CFRelease(windowList);
}

- (IBAction)showPreferencesWindow:(id)sender
{
  NSLog(@"showPreferencesWindow");
  [_preferencesWindow setLevel:NSFloatingWindowLevel];
  [_preferencesWindow makeKeyAndOrderFront:self];
}

- (IBAction)play:(id)sender
{
    //[self setLog:@"Received play event"];
    [self performAction:@"Start"];
}

- (IBAction)playOrPause:(id)sender
{
    //[self setLog:@"Received playOrPause event"];
    [self performAction:@"PlayOrPause"];

}

- (IBAction)stop:(id)sender
{
    //[self setLog:@"Received stop event"];
    [self performAction:@"Stop"];

}

- (IBAction)next:(id)sender
{
    //[self setLog:@"Received next event"];
    [self performAction:@"StartNext"];

}

- (IBAction)previous:(id)sender
{
    //[self setLog:@"Received previous event"];
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
  
  return url;
  
}

/*
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
*/

- (void)performAction:(NSString*)action
{
  
  [_systemTray animateStatusIcon];
    
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
      
      /*
      [NSThread sleepForTimeInterval:0.25];
      //usleep(250000);
      
      [self refreshPlayingInfo];
      */
      
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