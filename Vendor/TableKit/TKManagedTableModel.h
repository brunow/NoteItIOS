//
//  BKTableModelManagedListDataController.h
//  CellMappingExample
//
//  Created by Bruno Wernimont on 31/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "TKTableModel.h"

typedef NSFetchedResultsController*(^TKManagedTableModelFetchedResultsControllerBlock)();

@interface TKManagedTableModel : TKTableModel<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) id<NSFetchedResultsControllerDelegate, NSObject> fetchedResultsControllerDelegate;

/**
 Return the number of section from model
 @return The number of section from model
 */
- (NSInteger)numberOfSections;

/**
 Return the number of rows in section from model
 @param section An index number that identifies a section of the model
 @return The number of rows
 */
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

/**
 Setter for the fetched controller block creation
 @param block Block that will be called to created the fetched result controller
 */
- (void)setFetchedResultsControllerWithBlock:(TKManagedTableModelFetchedResultsControllerBlock)block;

@end
