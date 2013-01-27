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

#import "NSManagedObject+BWBackendObjectUpdate.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSManagedObject (BWBackendObjectUpdate)

@dynamic objectChange;
@dynamic objectChangedAt;


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BWBackendObjectUpdateChangeType)objectChangeType {
    return [self.objectChange intValue];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObjectChangeType:(BWBackendObjectUpdateChangeType)change {
    self.objectChange = [NSNumber numberWithInt:change];
    self.objectChangedAt = [NSDate date];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObjectNeedToBeSynced:(BOOL)needSyncing {
    [self setObjectChangeType:(needSyncing) ? BWBackendObjectUpdateChangeUpdate : BWBackendObjectUpdateChangeNone];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)objectNeedToBeSynced {
    return self.objectChangeType != BWBackendObjectUpdateChangeNone;
}


@end
