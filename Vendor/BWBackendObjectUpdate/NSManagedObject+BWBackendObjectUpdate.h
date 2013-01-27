//
// Created by Bruno Wernimont on 2013
// Copyright 2012 BWBackendObjectUpdate
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

#import <CoreData/CoreData.h>

typedef enum {
    BWBackendObjectUpdateChangeNone = 0,
    BWBackendObjectUpdateChangeInsert = 2000,
    BWBackendObjectUpdateChangeUpdate = 3000,
    BWBackendObjectUpdateChangeDelete = 4000
} BWBackendObjectUpdateChangeType;

@interface NSManagedObject (BWBackendObjectUpdate)

@property (nonatomic, retain) NSNumber *objectChange;
@property (nonatomic, strong) NSDate *objectChangedAt;

- (BWBackendObjectUpdateChangeType)objectChangeType;

- (void)setObjectChangeType:(BWBackendObjectUpdateChangeType)change;

- (void)setObjectNeedToBeSynced:(BOOL)needSyncing;

- (BOOL)objectNeedToBeSynced;

@end
