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

@interface NSArray (BaseKit)

/**
 * Convinient method to check if the array is empty or not.
 */
@property (nonatomic, readonly) BOOL isEmpty;

/**
 * Simply return the first object or nil if array is empty.
 */
- (id)firstObject;

/**
 * Return boolean value at given index
 */
- (BOOL)boolValueAtIndex:(NSInteger)index;

/**
 * Return int value at given index
 */
- (int)intValueAtIndex:(NSInteger)index;

/**
 * Return integer value at given index
 */
- (NSInteger)integerValueAtIndex:(NSInteger)index;

/**
 * Return float value at given index
 */
- (float)floatValueAtIndex:(NSInteger)index;

/**
 * Return double value at given index
 */
- (double)doubleValueAtIndex:(NSInteger)index;

/**
 * Return string value at given index
 */
- (NSString *)stringValueAtIndex:(NSInteger)index;

/**
 * Return number value at given index
 */
- (NSNumber *)numberValueAtIndex:(NSInteger)index;

@end
