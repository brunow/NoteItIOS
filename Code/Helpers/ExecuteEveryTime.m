//
// Created by Bruno Wernimont on 2013
// Copyright 2013 NoteIT
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "ExecuteEveryTime.h"

#import "BlocksKit.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ExecuteEveryTime


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)executeBlock:(BKBasicBlock)block everyTime:(NSTimeInterval)interval name:(NSString *)name {
    if (nil == block)
        return;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                       block:^(NSTimeInterval time) {
                                                           block();
                                                    
                                                       } repeats:YES];
    
    [[self sharedDictonnary] setObject:timer forKey:name];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)stopExecuteBlockWithName:(NSString *)name {
    NSTimer *timer = [[self sharedDictonnary] objectForKey:name];
    [timer invalidate];
    [[self sharedDictonnary] removeObjectForKey:name];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSMutableDictionary *)sharedDictonnary {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[NSMutableDictionary alloc] init];
    });
    return _sharedObject;
}


@end
