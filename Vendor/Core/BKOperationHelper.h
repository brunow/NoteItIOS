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

@interface BKOperationHelper : NSObject

/**
 * Execute block in another thread
 *
 * Execute your long operation, after operation is finish the finish block is called in the main thread
 *
 * <h3>Example</h3>
 *
 * @code
 * [BKOperationHelper performBlockInBackground:^{
 *      // Load for example table view items
 * } completion:^{
 *      // Reload date in the main thread
 *      [self.tableView reloadData];
 * }] waitUntilDone:YES;
 * @endcode
 */
+ (void)performBlockInBackground:(BKBasicBlock)block completion:(BKBasicBlock)completionBlock waitUntilDone:(BOOL)waitUntilDone;

+ (void)performBlockInBackground:(BKBasicBlock)block completion:(BKBasicBlock)completionBlock;

+ (void)performBlockInBackground:(BKBasicBlock)block;


/**
 * Execute block in main thread
 *
 * Execute your long operation in main thread
 *
 * <h3>Example</h3>
 *
 * @code
 * [BKOperationHelper performBlockInMainThread:^{
 *  } waitUntilDone:NO];
 * @endcode
 */
+ (void)performBlockInMainThread:(BKBasicBlock)block waitUntilDone:(BOOL)waitUntilDone;

+ (void)performBlockInMainThread:(BKBasicBlock)block;

@end
