//
// Created by Bruno Wernimont on 2012
// Copyright 2012 TableKit
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

#import "TKBlocks.h"

@class TKTableModel;

@interface TKCellMapping : NSObject

@property (nonatomic, assign) Class objectClass;
@property (nonatomic, assign) Class cellClass;
@property (nonatomic, readonly, strong) NSMutableDictionary *attributeMappings;
@property (nonatomic, strong) UINib *nib;
@property (nonatomic, copy) TKTableViewCellSelectionBlock onSelectRowBlock;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, copy) TKCellRowHeightBlock rowHeightBlock;
@property (nonatomic, copy) TKTableViewCellWillDisplayCellBlock willDisplayCellBlock;
@property (nonatomic, copy) TKTableViewCommitEditingStyleBlock commitEditingStyleBlock;
@property (nonatomic, copy) TKTableViewEditingStyleBlock editingStyleBlock;
@property (nonatomic, copy) TKTableViewCanMoveObjectBlock canMoveObjectBlock;
@property (nonatomic, copy) TKTableViewMoveObjectBlock moveObjectBlock;
@property (nonatomic, copy) TKTableViewCanEditObjectBlock canEditObjectBlock;

/**
 Initializes and returns a cell mapping object having an objectClass
 @param objectClass Class object from object that you want to map
 */
- (id)initWithObjectClass:(Class)objectClass;

/**
 Create and returns a cell mapping object having an objectClass
 @param objectClass Class object from object that you want to map
 @param block Block that will set the mapping
 */
+ (id)mappingForObjectClass:(Class)objectClass block:(void(^)(TKCellMapping *cellMapping))block;

/**
 Map object keyPath to cell attribute
 @param keyPath The value keyPath
 @param attribute The cell attribute
 @param valueBlock Block that give a value as param
 */
- (void)mapKeyPath:(NSString *)keyPath
       toAttribute:(NSString *)attribute
        valueBlock:(TKCellValueBlock)valueBlock;

/**
 Map object keyPath to cell attribute
 @param keyPath The value keyPath
 @param attribute The cell attribute
 @param valueBlock Block that give a value and an object as params
 */
- (void)mapKeyPath:(NSString *)keyPath
       toAttribute:(NSString *)attribute
       objectBlock:(TKCellObjectBlock)objectBlock;

/**
 Map object keyPath to cell attribute
 @param keyPath The value keyPath
 @param attribute The cell attribute
 */
- (void)mapKeyPath:(NSString *)keyPath toAttribute:(NSString *)attribute;

/**
 Called to set specific row height
 */
- (void)rowHeightWithBlock:(TKCellRowHeightBlock)rowHeightBlock;

/**
 Called when the row is selected
 */
- (void)onSelectRowWithBlock:(TKTableViewCellSelectionBlock)onSelectRowBlock;

/**
 Called before displaying the cell
 */
- (void)willDisplayCellWithBlock:(TKTableViewCellWillDisplayCellBlock)willDisplayCellBlock;

/**
 Called when comiting editing style
 */
- (void)commitEditingStyleWithBlock:(TKTableViewCommitEditingStyleBlock)commitEditingStyleBlock;

/**
 Called to get the cell editing style
 */
- (void)editingStyleWithBlock:(TKTableViewEditingStyleBlock)editingStyleBlock;

/**
 Map the object to a cell
 @param cellClass The cell the we must used to map values
 */
- (void)mapObjectToCellClass:(Class)cellClass;

/**
 
 */
- (void)canMoveObjectWithBlock:(TKTableViewCanMoveObjectBlock)canMoveObjectBlock;

/**
 
 */
- (void)moveObjectWithBlock:(TKTableViewMoveObjectBlock)moveObjectBlock;

/**
 */
- (void)canEditObjectWithBlock:(TKTableViewCanEditObjectBlock)canEditObjectBlock;

@end
