//
// Created by Bruno Wernimont on 2012
// Copyright 2012 FormKit
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

#import "NSObject+FKFormAttributeMapping.h"

#import <objc/runtime.h>
#import "FKFormAttributeMapping.h"

static char FKFormAttributeMappingKey;


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSObject (FKFormAttributeMapping)

@dynamic formAttributeMapping;


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setFormAttributeMapping:(FKFormAttributeMapping *)formAttributeMapping {
    [self willChangeValueForKey:@"formAttributeMapping"];
    objc_setAssociatedObject(self, &FKFormAttributeMappingKey,
                             formAttributeMapping,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"formAttributeMapping"];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (FKFormAttributeMapping *)formAttributeMapping {
    return objc_getAssociatedObject(self, &FKFormAttributeMappingKey);
}


@end
