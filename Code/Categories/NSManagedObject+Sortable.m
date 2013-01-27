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

#import "NSManagedObject+Sortable.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSManagedObject (Sortable)

@dynamic position;


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSArray *)sortObjects:(NSArray *)objects toPosition:(NSUInteger)position withObject:(NSManagedObject *)object {
    NSMutableArray *mutableObjects = [objects mutableCopy];
    
    NSUInteger sourcePosition = MIN([mutableObjects indexOfObject:object], position);
    [mutableObjects removeObject:object];
    [mutableObjects insertObject:object atIndex:position];
    
    NSRange subArrayRange = NSMakeRange(sourcePosition, mutableObjects.count);
    NSArray *objectsToSort = [mutableObjects subarrayWithRange:subArrayRange];
    
    [objectsToSort enumerateObjectsUsingBlock:^(NSManagedObject *obj, NSUInteger idx, BOOL *stop) {
        NSUInteger objectPosition = sourcePosition + idx + 1;
        obj.position = [NSNumber numberWithUnsignedInteger:objectPosition];
    }];
    
    return objectsToSort;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)insertObjectInObjects:(NSArray *)objects
                   atPosition:(NSManagedObjectSortablePosition)position {
    
    NSUInteger objectPosition = 1;
    
    if (0 < objects.count) {
        NSManagedObject *lastObject = [objects lastObject];;
        objectPosition = [lastObject.position unsignedIntegerValue] + 1;
    }
    
    self.position = [NSNumber numberWithUnsignedInteger:objectPosition];
}


@end
