//
//  AppDelegate.h
//  Media Keys Installer
//
//  Created by Michael Feldstein on 1/11/14.
//  Copyright (c) 2014 Michael Feldstein. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSFileHandle* _stdOutOutputHandle;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSView *before;
@property (weak) IBOutlet NSView *after;

-(IBAction)install:(id)sender;
-(IBAction)uninstall:(id)sender;
-(IBAction)quit:(id)sender;
@end
