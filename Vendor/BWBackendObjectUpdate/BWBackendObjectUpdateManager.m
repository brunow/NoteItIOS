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

#import "BWBackendObjectUpdateManager.h"

#import "NSManagedObject+BWBackendObjectUpdate.h"

#import "CoreData+MagicalRecord.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BWBackendObjectUpdateManager ()

@property (nonatomic, strong) NSMutableSet *fetchedControllers;
@property (nonatomic, copy) BWBackendObjectChangeBlock objectUpdateBlock;

- (NSFetchedResultsController *)fetchedResultsControllerForEntity:(NSString *)entityName
                                                        inContext:(NSManagedObjectContext *)context;

- (void)callUpdateBlockForObject:(NSManagedObject *)object;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BWBackendObjectUpdateManager


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BWBackendObjectUpdateManager *)shared {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        self.fetchedControllers = [NSMutableSet set];
        self.updatingObjects = [NSMutableSet set];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)objectChangeWithBlock:(BWBackendObjectChangeBlock)block {
    self.objectUpdateBlock = block;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)watchObjectsUpdatesForEntity:(NSString *)entity {
    NSFetchedResultsController *resultController = [self fetchedResultsControllerForEntity:entity
                                                                                 inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    
    // Execute this on background to improve speed ?
    [resultController performFetch:nil];
    [self.fetchedControllers addObject:resultController];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)update {    
    [self.fetchedControllers enumerateObjectsUsingBlock:^(NSFetchedResultsController *fetchedController, BOOL *stop) {
        NSString *entityName = [[fetchedController fetchRequest] entityName];
        Class entityClass = NSClassFromString(entityName);
        NSArray *objects = [entityClass findAllWithPredicate:[NSPredicate predicateWithFormat:@"objectChange > 0"]];
        
        [objects enumerateObjectsUsingBlock:^(NSManagedObject *obj, NSUInteger idx, BOOL *stop) {
            if (NO == [self isObjectUpdating:obj]) {
                [self callUpdateBlockForObject:obj];
            }
        }];
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateInBackground {
    [BKOperationHelper performBlockInBackground:^{
        [self update];
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isUpdating {
    return [self.updatingObjects count] > 0;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isObjectUpdating:(NSManagedObject *)objectToCheck {
    __block BOOL isObjectUpdating = NO;
    
    [self.updatingObjects enumerateObjectsUsingBlock:^(NSManagedObject *obj, BOOL *stop) {
        if ([[[objectToCheck objectID] URIRepresentation] isEqual:[[obj objectID] URIRepresentation]]) {
            isObjectUpdating = YES;
            *stop = YES;
        }
    }];
    
    return isObjectUpdating;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeObjectFromUpdatingList:(NSManagedObject *)object {
    [self.updatingObjects removeObject:object];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(NSManagedObject *)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (NSFetchedResultsChangeUpdate == type || NSFetchedResultsChangeInsert == type) {
        BWBackendObjectUpdateChangeType changeType = [anObject objectChangeType];
        
        if (BWBackendObjectUpdateChangeNone != changeType) {
            [self callUpdateBlockForObject:anObject];
        }
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)callUpdateBlockForObject:(NSManagedObject *)object {
    [self.updatingObjects addObject:object];
    
    BWBackendObjectSuccessChangeBlock successCallbackBlock = ^(NSManagedObject *object) {
        [object setObjectChangeType:BWBackendObjectUpdateChangeNone];
        [object.managedObjectContext MR_saveNestedContexts];
        [self removeObjectFromUpdatingList:object];
    };
    
    BWBackendObjectFailureChangeBlock failureCallbackBlock = ^(NSManagedObject *object) {
        [self removeObjectFromUpdatingList:object];
    };
    
    self.objectUpdateBlock(object, [object objectChangeType], successCallbackBlock, failureCallbackBlock);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSFetchedResultsController *)fetchedResultsControllerForEntity:(NSString *)entityName
                                                        inContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSFetchedResultsController *fetchedResultController = nil;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:YES];
    NSString *cacheName = [NSString stringWithFormat:@"BWBackendObjectUpdateManager%@", entityName];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:0];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    [NSFetchedResultsController deleteCacheWithName:cacheName];
    
    fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                  managedObjectContext:context
                                                                    sectionNameKeyPath:nil
                                                                             cacheName:cacheName];
    
    fetchedResultController.delegate = self;
    return fetchedResultController;
}


@end
