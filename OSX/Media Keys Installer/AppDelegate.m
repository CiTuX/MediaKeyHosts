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
    NSString* installScriptPath = [[NSBundle mainBundle] pathForResource:@"install" ofType:@"sh"];
    
    NSLog(@"Script Path %@", installScriptPath);
    NSString* workingDirectory = [installScriptPath stringByDeletingLastPathComponent];
    NSLog(@"DIR %@", workingDirectory);
    AuthorizationRef authRef;
    OSStatus status = AuthorizationCreate(NULL,
                                          kAuthorizationEmptyEnvironment,
                                          kAuthorizationFlagDefaults,
                                          &authRef
                                          );
    if (status != errAuthorizationSuccess) {
        NSLog(@":(");
    }
    
    AuthorizationItem kAuthEnv[1];
    NSString* iconPathNS = [[NSBundle mainBundle] pathForResource:@"sway512" ofType:@"png"];
    const char *iconPath = [iconPathNS cStringUsingEncoding:NSASCIIStringEncoding];
    kAuthEnv[0].name = kAuthorizationEnvironmentIcon;
    kAuthEnv[0].valueLength = strlen(iconPath);
    kAuthEnv[0].value = (void *)iconPath; // fully qualified path
    kAuthEnv[0].flags = 0;
    AuthorizationEnvironment authorizationEnvironment;
    authorizationEnvironment.items = kAuthEnv;
    authorizationEnvironment.count = 1;
    
    const char* scriptPath = [installScriptPath cStringUsingEncoding:NSASCIIStringEncoding];
    AuthorizationItem executeRight = {
        kAuthorizationRightExecute,
        strlen(scriptPath),
        (void*)scriptPath,
        0
    };
    AuthorizationRights rightsSet = {1, &executeRight};
    AuthorizationFlags flags =
        kAuthorizationFlagDefaults |
        kAuthorizationFlagInteractionAllowed |
        kAuthorizationFlagPreAuthorize |
        kAuthorizationFlagExtendRights;
    status = AuthorizationCopyRights(authRef, &rightsSet, &authorizationEnvironment, flags, NULL);
    if (errAuthorizationCanceled == status) {
        NSLog(@"Cancelled");
    } else if (status != errAuthorizationSuccess) {
        NSLog(@"Error authenticating");
    }
    
    FILE* fpStdout = NULL;
    char *args[2];
    args[0] = [workingDirectory cStringUsingEncoding:NSASCIIStringEncoding];
    args[1] = NULL;
    status = AuthorizationExecuteWithPrivileges(
        authRef,
        (const char*)scriptPath,
        kAuthorizationFlagDefaults,
        args,
        &fpStdout
    );
    
    bool success = (status == errAuthorizationSuccess);
    pid_t newProcId;
    if (success)
    {
        int commPipeFD = fileno(fpStdout);
        _stdOutOutputHandle = [[NSFileHandle alloc] initWithFileDescriptor:commPipeFD];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataRead:) name:NSFileHandleReadCompletionNotification object:_stdOutOutputHandle];
        [_stdOutOutputHandle readInBackgroundAndNotify];

        //        // Get the new process id
//        newProcId = fcntl(fileno(fpStdout), F_GETOWN, 0);
//        fclose(fpStdout);
    }
    else
    {
        // Notify user of the error ...
    }
    
}

- (void)dataRead:(NSNotification*)notification {
    NSData *data = [[notification userInfo] objectForKey:@"NSFileHandleNotificationDataItem"];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([string isEqualToString:@"SUCCESS\n"]) {
        NSLog(@"SUCCESS!!!");
        [self.before setHidden:YES];
        [self.after setHidden:NO];
        
    } else {
        NSLog(@"FAILURE!!!!");
    }
}

-(IBAction)quit:(id)sender {
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end
