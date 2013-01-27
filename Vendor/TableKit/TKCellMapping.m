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

#import "TKCellMapping.h"

#import "TKTableModel.h"
#import "TKCellAttributeMapping.h"
#import "TKCellAttributeMapping.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TKCellMapping ()

- (void)addAttributeMappingToObjectMapping:(TKCellAttributeMapping *)attributeMapping;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TKCellMapping

@synthesize objectClass = _objectClass;
@synthesize attributeMappings = _attributeMappings;
@synthesize cellClass = _cellClass;
@synthesize nib = _nib;
@synthesize onSelectRowBlock = _onSelectRowBlock;
@synthesize rowHeight = _rowHeight;
@synthesize rowHeightBlock = _rowHeightBlock;
@synthesize willDisplayCellBlock = _willDisplayCellBlock;
@synthesize commitEditingStyleBlock = _commitEditingStyleBlock;
@synthesize editingStyleBlock = _editingStyleBlock;


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    
    if (self) {
        _attributeMappings = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithObjectClass:(Class)objectClass {
    self = [self init];
    if (self) {
        self.objectClass = objectClass;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)mappingForObjectClass:(Class)objectClass block:(void(^)(TKCellMapping *cellMapping))block {
    TKCellMapping *cellMapping = [[self alloc] initWithObjectClass:objectClass];
    block(cellMapping);
    return cellMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapKeyPath:(NSString *)keyPath
       toAttribute:(NSString *)attribute
        valueBlock:(TKCellValueBlock)valueBlock {
    
    TKCellAttributeMapping *attributeMapping = [TKCellAttributeMapping attributeMapping];
    attributeMapping.mappingType = TKCellAttributeMappingTypeDefault;
    attributeMapping.keyPath = keyPath;
    attributeMapping.attribute = attribute;
    attributeMapping.valueBlock = valueBlock;
    
    [self addAttributeMappingToObjectMapping:attributeMapping];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapKeyPath:(NSString *)keyPath
           toAttribute:(NSString *)attribute
        objectBlock:(TKCellObjectBlock)objectBlock {
    
    TKCellAttributeMapping *attributeMapping = [TKCellAttributeMapping attributeMapping];
    attributeMapping.mappingType = TKCellAttributeMappingTypeDefault;
    attributeMapping.keyPath = keyPath;
    attributeMapping.attribute = attribute;
    attributeMapping.objectBlock = objectBlock;
    
    [self addAttributeMappingToObjectMapping:attributeMapping];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapKeyPath:(NSString *)keyPath toAttribute:(NSString *)attribute {
    [self mapKeyPath:keyPath toAttribute:attribute valueBlock:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapObjectToCellClass:(Class)cellClass {
    self.cellClass = cellClass;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)rowHeightWithBlock:(TKCellRowHeightBlock)rowHeightBlock {
    self.rowHeightBlock = rowHeightBlock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)onSelectRowWithBlock:(TKTableViewCellSelectionBlock)onSelectRowBlock {
    self.onSelectRowBlock = onSelectRowBlock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willDisplayCellWithBlock:(TKTableViewCellWillDisplayCellBlock)willDisplayCellBlock {
    self.willDisplayCellBlock = willDisplayCellBlock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)commitEditingStyleWithBlock:(TKTableViewCommitEditingStyleBlock)commitEditingStyleBlock {
    self.commitEditingStyleBlock = commitEditingStyleBlock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)editingStyleWithBlock:(TKTableViewEditingStyleBlock)editingStyleBlock {
    self.editingStyleBlock = editingStyleBlock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)canMoveObjectWithBlock:(TKTableViewCanMoveObjectBlock)canMoveObjectBlock {
    self.canMoveObjectBlock = canMoveObjectBlock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)moveObjectWithBlock:(TKTableViewMoveObjectBlock)moveObjectBlock {
    self.moveObjectBlock = moveObjectBlock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)canEditObjectWithBlock:(TKTableViewCanEditObjectBlock)canEditObjectBlock {
    self.canEditObjectBlock = canEditObjectBlock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addAttributeMappingToObjectMapping:(TKCellAttributeMapping *)attributeMapping {
    [self.attributeMappings setObject:attributeMapping forKey:attributeMapping.keyPath];
}


@end
