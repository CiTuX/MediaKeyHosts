//
//  main.m
//  Media Keys Handler
//
//  Created by Michael Feldstein on 12/29/13.
//  Copyright (c) 2013 Michael Feldstein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPMediaKeyTap.h"
#import "FMMediaKeyDelegate.h"


int main(int argc, const char * argv[])
{

    @autoreleasepool {
        FMMediaKeyDelegate* delegate = [[FMMediaKeyDelegate alloc] init];
        SPMediaKeyTap* keyTap = [[SPMediaKeyTap alloc] initWithDelegate:delegate];
        [keyTap startWatchingMediaKeys];
        NSRunLoop* loop = [NSRunLoop currentRunLoop];
        [loop run];
        [delegate release];
        [keyTap release];
        [loop release];
    }
    return 0;
}

