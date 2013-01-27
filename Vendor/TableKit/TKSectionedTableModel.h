//
//  TKSectionedTableModel.h
//  TableKitDemo
//
//  Created by cesar4 on 30/07/12.
//
//

#import <Foundation/Foundation.h>

#import "TKTableModel.h"

@interface TKSectionedTableModel : TKTableModel{
    NSMutableArray *_items;
    NSMutableArray *_sections;
}

/**
 Mutable array of items
 */
@property (nonatomic, readonly, strong) NSMutableArray *items;

/**
 Mutable array of section titles
 */
@property (nonatomic, readonly, strong) NSMutableArray *sections;

@property (nonatomic, copy, readonly) TKTableViewForHeaderInSectionViewBlock viewForHeaderInSectionBlock;

/**
 Block that create a section view with title
 @param viewForHeaderInSectionBlock Block that will create the section view
 */
- (void)setViewForHeaderInSectionWithBlock:(TKTableViewForHeaderInSectionViewBlock)viewForHeaderInSectionBlock;

/**
 Load list of items into the tableview
 @param items
 @param sections Array of string that are section titles
 */
- (void)loadTableItems:(NSArray *)items withSections:(NSArray *)sections;

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
