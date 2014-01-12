//
//  AppDelegate.h
//  Media Keys Installer
//
//  Created by Michael Feldstein on 1/11/14.
//  Copyright (c) 2014 Michael Feldstein. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

-(IBAction)install:(id)sender;
@end
