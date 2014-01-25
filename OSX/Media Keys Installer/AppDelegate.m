//
//  AppDelegate.m
//  Media Keys Installer
//
//  Created by Michael Feldstein on 1/11/14.
//  Copyright (c) 2014 Michael Feldstein. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{}

- (IBAction)install:(id)sender
{
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* manifestPath = [bundle pathForResource:@"fm.sway.mediakeys" ofType:@"json-template"];
    NSError* error;
    NSString* libraryDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* hostsDir = [libraryDir stringByAppendingString:@"/Google/Chrome/NativeMessagingHosts"];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:hostsDir withIntermediateDirectories:YES attributes:nil error:&error];
    NSString* manifestContents = [NSString stringWithContentsOfFile:manifestPath encoding:NSASCIIStringEncoding error:NULL];
    NSString* manifestInstallPath = [hostsDir stringByAppendingString:@"/mediakeys"];
    manifestContents = [manifestContents stringByReplacingOccurrencesOfString:@"%BINARY_PATH%" withString:manifestInstallPath];
    NSString* binPath = [bundle pathForResource:@"mediakeys" ofType:@""];
    NSString* binDest = [hostsDir stringByAppendingString:@"/mediakeys"];
    [[NSFileManager defaultManager] copyItemAtPath:binPath toPath:binDest error:&error];
    
    [self.before setHidden:YES];
    [self.after setHidden:NO];
}

-(IBAction)quit:(id)sender {
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end
