//
//  StdinListener.m
//  Media Keys Handler
//
//  Created by Michael Feldstein on 1/12/14.
//  Copyright (c) 2014 Michael Feldstein. All rights reserved.
//

#import "StdinListener.h"

@implementation StdinListener

- (id)init {
    self = [super init];
    if (self) {
        _stdin = [NSFileHandle fileHandleWithStandardInput];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataRead:) name:NSFileHandleReadCompletionNotification object:_stdin];
        [_stdin readInBackgroundAndNotify];
    }
    return self;
}

- (void)dataRead:(NSNotification*)notification
{
    NSData *data = [[notification userInfo] objectForKey:@"NSFileHandleNotificationDataItem"];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"STring '%@'", string);

    NSLog(@"Done");
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    int processID = [processInfo processIdentifier];
    exit(0);
}

@end
