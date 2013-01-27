//
//  BKTableModelListDataController.h
//  CellMappingExample
//
//  Created by Bruno Wernimont on 31/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TKTableModel.h"

@interface TKListTableModel : TKTableModel {
    NSMutableArray *_items;
}

/**
 Mutable array of items
 */
@property (nonatomic, readonly, strong) NSMutableArray *items;

/**
 Load list of items into the tableview
 @param items List of items
 */
- (void)loadTableItems:(NSArray *)items;

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

@end
