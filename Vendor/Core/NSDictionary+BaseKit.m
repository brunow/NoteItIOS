//
// Created by Bruno Wernimont on 2012
// Copyright 2012 BaseKit
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

#import "NSDictionary+BaseKit.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSDictionary (BaseKit)


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isEmpty {
    return (self.count == 0) ? YES : NO;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)containsObjectForKey:(id)key {
    return ([self objectForKey:key] == nil) ? NO : YES;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectForKey:(id)aKey defaultObject:(id)defaultObject {
    return ([self containsObjectForKey:aKey]) ? [self objectForKey:aKey] : defaultObject;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)boolValueForKey:(id)aKey defaultValue:(BOOL)defaultValue {
    NSNumber *number = [self objectForKey:aKey
                            defaultObject:[NSNumber numberWithBool:defaultValue]];
    
    return [number boolValue];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)boolValueForKey:(id)aKey {
    return [[self objectForKey:aKey] boolValue];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (int)intValueForKey:(id)aKey defaultValue:(int)defaultValue {
    NSNumber *number = [self objectForKey:aKey
                            defaultObject:[NSNumber numberWithInt:defaultValue]];
    
    return [number intValue];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (int)intValueForKey:(id)aKey {
    return [[self objectForKey:aKey] intValue];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (float)floatValueForKey:(id)aKey defaultValue:(float)defaultValue {
    NSNumber *number = [self objectForKey:aKey
                            defaultObject:[NSNumber numberWithFloat:defaultValue]];
    
    return [number floatValue];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (float)floatValueForKey:(id)aKey {
    return [[self objectForKey:aKey] floatValue];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)integerValueForKey:(id)aKey defaultValue:(NSInteger)defaultValue {
    NSNumber *number = [self objectForKey:aKey
                            defaultObject:[NSNumber numberWithInteger:defaultValue]];
    
    return [number integerValue];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)integerValueForKey:(id)aKey {
    return [[self objectForKey:aKey] integerValue];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (double)doubleValueForKey:(id)aKey defaultValue:(NSInteger)defaultValue {
    NSNumber *number = [self objectForKey:aKey
                            defaultObject:[NSNumber numberWithDouble:defaultValue]];
    
    return [number doubleValue];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (double)doubleValueForKey:(id)aKey {
    return [[self objectForKey:aKey] doubleValue];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)stringValueForKey:(id)aKey defaultValue:(NSString *)defaultValue {
    return [self objectForKey:aKey
                defaultObject:defaultValue];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)stringValueForKey:(id)aKey {
    return [self objectForKey:aKey];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSNumber *)numberValueForKey:(id)aKey defaultValue:(NSNumber *)defaultValue {
    return [self objectForKey:aKey
                defaultObject:defaultValue];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSNumber *)numberValueForKey:(id)aKey {
    return [self objectForKey:aKey];
}


@end
