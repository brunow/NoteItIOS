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

#import "TKTableModel.h"

#import "UITableViewCell+TableKit.h"
#import "TKCellAttributeMapping.h"
#import "TKCellMapping.h"
#import "TKCellMapper.h"
#import "UITableViewCell+TableKit.h"

#import "TKTableModel+Private.h"
#import <objc/runtime.h>

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TKTableModel ()

- (TKCellMapping *)cellMappingForObject:(id)object;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TKTableModel

@synthesize tableView = _tableView;
@synthesize objectMappings = _objectMappings;
@synthesize objectForRowAtIndexPathBlock = _objectForRowAtIndexPathBlock;


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
//    dispatch_release(_concurrentQueue);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)tableModelForTableView:(UITableView *)tableView {
    TKTableModel *tableModel = [[self alloc] initWithTableView:tableView];
    return tableModel;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTableView:(UITableView *)tableView {
    self = [self init];
    
    if (self) {
        self.tableView = tableView;
    }
    
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    
    if (self) {
        _concurrentQueue = dispatch_queue_create("be.tableKit.cellmapping.tablebodel", NULL);
        _objectMappings = [NSMutableDictionary dictionary];
    }
    
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)registerMapping:(TKCellMapping *)cellMapping {
    NSString *objectClassStringName = NSStringFromClass(cellMapping.objectClass);
    
    NSMutableSet *set = [self.objectMappings objectForKey:objectClassStringName];
    
    if (nil == set) {
        set = [NSMutableSet set];
    }
    
    if (nil == [self.objectMappings objectForKey:cellMapping]) {
        [self.objectMappings setObject:set forKey:objectClassStringName];
    }
    
    [set addObject:cellMapping];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectForRowAtIndexPath:indexPath];
    TKCellMapping *cellMapping = [self cellMappingForObject:object];
    
    if (nil != cellMapping.onSelectRowBlock) {
        UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        cellMapping.onSelectRowBlock(cell, object, indexPath);
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectForRowAtIndexPath:indexPath];
    TKCellMapping *cellMapping = [self cellMappingForObject:object];
    
    CGFloat rowHeight = 0;
    
    if (nil != cellMapping.rowHeightBlock) {
        rowHeight = cellMapping.rowHeightBlock(cellMapping.cellClass, object, indexPath);
    } else if (cellMapping.rowHeight > 0) {
        rowHeight = cellMapping.rowHeight;
    } else {
        rowHeight = self.tableView.rowHeight;
    }
    
    return rowHeight;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectForRowAtIndexPath:indexPath];
    TKCellMapping *cellMapping = [self cellMappingForObject:object];
    
    if (nil != cellMapping.willDisplayCellBlock) {
        cellMapping.willDisplayCellBlock(cell, object, indexPath);
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
         forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [self objectForRowAtIndexPath:indexPath];
    TKCellMapping *cellMapping = [self cellMappingForObject:object];
    
    if (nil != cellMapping.commitEditingStyleBlock) {
        cellMapping.commitEditingStyleBlock(object, indexPath, editingStyle);
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCellEditingStyle)editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectForRowAtIndexPath:indexPath];
    TKCellMapping *cellMapping = [self cellMappingForObject:object];
    
    if (nil != cellMapping.editingStyleBlock) {
        return cellMapping.editingStyleBlock(object, indexPath);
    }
    
    return UITableViewCellEditingStyleNone;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)objectForRowAtIndexPathWithBlock:(TKObjectForRowAtIndexPathBlock)block {
    self.objectForRowAtIndexPathBlock = block;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (nil != self.objectForRowAtIndexPathBlock) {
        return self.objectForRowAtIndexPathBlock(indexPath);
    }
    
    return nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectForRowAtIndexPath:indexPath];;
    TKCellMapping *cellMapping = [self cellMappingForObject:object];
    UITableViewCell *cell = nil;
    
    if (nil == cellMapping.nib) {
        cell = [cellMapping.cellClass cellForTableView:self.tableView];
    } else {
        cell = [cellMapping.cellClass cellForTableView:self.tableView fromNib:cellMapping.nib];
    }
    
    [TKCellMapper mapCellAttributeWithMapping:cellMapping object:object cell:cell];
    
#ifndef DEBUG
    if (nil == cell) {
        cell = [UITableViewCell cellForTableView:self.tableView];
    }
#endif
    
    return cell;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadItems {
    [self.tableView reloadData];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDataSource


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellForRowAtIndexPath:indexPath];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForRowAtIndexPath:indexPath];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self willDisplayCell:cell forRowAtIndexPath:indexPath];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    id object = [self objectForRowAtIndexPath:sourceIndexPath];
    TKCellMapping *cellMapping = [self cellMappingForObject:object];
    
    if (nil != cellMapping.moveObjectBlock)
        cellMapping.moveObjectBlock(object, sourceIndexPath, destinationIndexPath);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectForRowAtIndexPath:indexPath];
    TKCellMapping *cellMapping = [self cellMappingForObject:object];
    
    UITableViewCellEditingStyle editingStyle = [self tableView:tableView
                                 editingStyleForRowAtIndexPath:indexPath];
    
    BOOL canEdit = NO;
    
    if (nil != cellMapping.canEditObjectBlock)
        canEdit = cellMapping.canEditObjectBlock(object, indexPath, editingStyle);
    
    if (nil != cellMapping.canMoveObjectBlock)
        canEdit = canEdit || cellMapping.canMoveObjectBlock(object, indexPath);
    
    return canEdit;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDelegate


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self didSelectRowAtIndexPath:indexPath];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self editingStyleForRowAtIndexPath:indexPath];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectForRowAtIndexPath:indexPath];
    TKCellMapping *cellMapping = [self cellMappingForObject:object];
    
    if (nil != cellMapping.canMoveObjectBlock)
        return cellMapping.canMoveObjectBlock(object, indexPath);
    
    return NO;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Forward unimplemented methods


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldForwardSelectorToDelegate:(SEL)aSelector {
    struct objc_method_description description;
    description = protocol_getMethodDescription(@protocol(UIScrollViewDelegate), aSelector, NO, YES);
    BOOL isSelectorInScrollViewDelegate = (description.name != NULL && description.types != NULL);
    
    return (isSelectorInScrollViewDelegate && [self.delegate respondsToSelector:aSelector]);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector] == YES) {
        return YES;
    }
    
    return [self shouldForwardSelectorToDelegate:aSelector];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self shouldForwardSelectorToDelegate:aSelector]) {
        return self.delegate;
    }
    
    return nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (TKCellMapping *)cellMappingForObject:(id)object {
    __weak __block TKCellMapping *cellMapping = nil;
    
    dispatch_sync(_concurrentQueue, ^{
        NSSet *cellMappings = [TKCellMapper cellMappingsForObject:object mappings:self.objectMappings];
        cellMapping = [TKCellMapper cellMappingForObject:object mappings:cellMappings];
    });
    
    return cellMapping;
}


@end
