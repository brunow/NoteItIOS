KSReachability
==============

By Karl Stenerud

### A better reachability for a modern age.


Introduction
------------

A long time ago in an Xcode far away, Apple provided "Reachability", an example
Objective-C wrapper to demonstrate the SystemConfiguration Reachability APIs. On the
whole it works well enough, but it could be so much more!

KSReachability takes reachability to the next level.


Features
--------

- Notifications/callbacks via NSNotification, blocks, and KVO.
- Fetching status values doesn't block.
- Callbacks always occur on the main thread, so it's UI-safe.
- KSReachableOperation: A one-shot operation to perform when reachability is established.
- Supports iOS and Mac OS X.
- Can be built with or without ARC, in CLANG or GCC.

Usage
-----

#### Import:
    #import "KSReachability.h"

#### Create a KSReachability object:
    self.reachability = [KSReachability reachabilityToHost:hostname];

#### Use blocks:
    self.reachability.onReachabilityChanged = ^(KSReachability* reachability)
    {
        NSLog(@"Reachability changed to %d (blocks)", reachability.reachable);
    };

#### Or use NSNotifications:
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onReachabilityChanged:)
                                                 name:kDefaultNetworkReachabilityChangedNotification
                                               object:nil];
    ...

    self.reachability.notificationName = kDefaultNetworkReachabilityChangedNotification;
    ...

    - (void) onReachabilityChanged:(NSNotification*) notification
    {
        KSReachability* reachability = (KSReachability*)notification.object;
        NSLog(@"Reachability changed to %d (NSNotification)", reachability.reachable);
    }

#### Or use KVO:
    [self.reachability addObserver:self
                        forKeyPath:@"reachable"
                           options:NSKeyValueObservingOptionNew
                           context:NULL];
    ...

    - (void)observeValueForKeyPath:(NSString *)keyPath
                          ofObject:(id)object
                            change:(NSDictionary *)change
                           context:(void *)context
    {
        KSReachability* reachability = (KSReachability*)object;
        NSLog(@"Reachability changed to %d (KVO)", reachability.reachable);
    }

#### Add a reachable operation:
    // Create a one-shot operation that gets fired once the host is reachable.
    self.reachableOperation = [KSReachableOperation operationWithHost:hostname
                                                            allowWWAN:NO
                                                                block:^
                               {
                                   [self showAlertWithTitle:@"One-time message"
                                                    message:@"Host is reachable!"];
                               }];


Full Example
------------

I've included a full example project in this repository.

In **iOSReachability**, see **ViewController.h** and **ViewController.m** for details.

In **MacReachability**, see **AppDelegate.h** and **AppDelegate.m** for details.


License
-------

Copyright (c) 2012 Karl Stenerud. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall remain in place
in this source code.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
