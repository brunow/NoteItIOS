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

#import <CoreData/CoreData.h>

typedef enum {
    NSManagedObjectSortablePositionBottom
} NSManagedObjectSortablePosition;


@interface NSManagedObject (Sortable)

@property (nonatomic, retain) NSNumber * position;

+ (NSArray *)sortObjects:(NSArray *)objects toPosition:(NSUInteger)position withObject:(NSManagedObject *)object;

- (void)insertObjectInObjects:(NSArray *)objects
                   atPosition:(NSManagedObjectSortablePosition)position;

@end
