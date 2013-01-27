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

#import <Foundation/Foundation.h>

#import "BKBlocks.h"

@interface BKIteratingHelper : NSObject

#if NS_BLOCKS_AVAILABLE

/**
 * Iterate from zero til a given number by a given slice and execute each time a block.
 *
 * <h3>Example</h3>
 *
 * @code
 * [BWIterating iterateTil:10 bySlice:2 usingBlock:^(int number) {
 *      NSLog(@"Number %d", number);
 * }];
 * @endcode
 */
+ (void)iterateTil:(int)iterateTil bySlice:(int)slice usingBlock:(BKIterationBlock)iterationBlock;

/**
 * Iterate from zero til a given number and execute each time a block.
 *
 * <h3>Example</h3>
 *
 * @code
 * [BWIterating iterateTil:10 usingBlock:^(int number) {
 *      NSLog(@"Number %d", number);
 * }];
 * @endcode
 */
+ (void)iterateTil:(int)iterateTil usingBlock:(BKIterationBlock)iterationBlock;

#endif

@end
