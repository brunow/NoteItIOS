//
// Created by Bruno Wernimont on 2012
// Copyright 2012 BWLongTextViewController
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

#import "BWSelectViewController.h"

static NSString *CellIdentifier = @"Cell";

#define TITLE_KEY @"title"
#define ITEMS_KEY @"items"


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BWSelectViewController ()

- (NSArray *)itemsFromSection:(NSInteger)section;

- (BOOL)isSectionSelected:(NSInteger)section;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BWSelectViewController

@synthesize sections = _sections;
@synthesize selectedIndexPaths = _selectedIndexPaths;
@synthesize multiSelection = _multiSelection;
@synthesize cellClass = _cellClass;
@synthesize allowEmpty = _allowEmpty;
@synthesize selectBlock = _selectBlock;
@synthesize sectionOrders = _sectionOrders;
@synthesize dropDownSection = _dropDownSection;


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithItems:(NSArray *)items
        multiselection:(BOOL)multiSelection
            allowEmpty:(BOOL)allowEmpty
         selectedItems:(NSArray *)selectedItems
           selectBlock:(BWSelectViewControllerDidSelectBlock)selectBlock {
    
    self = [self initWithSections:nil
                           orders:nil
                   multiselection:multiSelection
                       allowEmpty:allowEmpty
                    selectedItems:selectedItems
                      selectBlock:selectBlock];
    
    if (self) {
        [self setItems:items];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithSections:(NSDictionary *)sections
                orders:(NSArray *)orders
        multiselection:(BOOL)multiSelection
            allowEmpty:(BOOL)allowEmpty
         selectedItems:(NSArray *)selectedItems
           selectBlock:(BWSelectViewControllerDidSelectBlock)selectBlock {
    
    self = [self init];
    if (self) {
        self.multiSelection = multiSelection;
        self.allowEmpty = allowEmpty;
        [self.selectedIndexPaths addObjectsFromArray:selectedItems];
        self.selectBlock = selectBlock;
        [self setSections:sections orders:orders];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    return [self initWithStyle:UITableViewStyleGrouped];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.multiSelection = NO;
        self.cellClass = [UITableViewCell class];
        self.allowEmpty = NO;
        _selectedIndexPaths = [[NSMutableArray alloc] init];
        self.dropDownSection = NO;
        self.scrollToRowScrollPositionOnSelect = UITableViewScrollPositionNone;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.selectedIndexPaths.count > 0) {
        NSIndexPath *selectedIndexPath = [self.selectedIndexPaths lastObject];
        
        [self.tableView scrollToRowAtIndexPath:selectedIndexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setDidSelectBlock:(BWSelectViewControllerDidSelectBlock)didSelectBlock {
    self.selectBlock = didSelectBlock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSlectedIndexPaths:(NSArray *)indexPaths {
    [self.selectedIndexPaths removeAllObjects];
    [self.selectedIndexPaths addObjectsFromArray:indexPaths];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)sectionOrders {
    return (nil == _sectionOrders) ?
        [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] :
        _sectionOrders;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setItems:(NSArray *)items {
    self.sections = [NSDictionary dictionaryWithObject:items forKey:@""];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)items {
    return [[self.sections allValues] objectAtIndex:0];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSections:(NSDictionary *)sections orders:(NSArray *)orders {
    self.sections = sections;
    self.sectionOrders = orders;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectWithIndexPath:(NSIndexPath *)indexPath {
    return [[self itemsFromSection:indexPath.section] objectAtIndex:indexPath.row];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)selectedObjects {
    NSMutableArray *objects = [NSMutableArray array];
    
    [self.selectedIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        [objects addObject:[self objectWithIndexPath:indexPath]];
    }];
    
    return objects;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSelectedIndexPathsWithObject:(id)object {
    [self setSelectedIndexPathsWithObjects:[NSArray arrayWithObject:object]];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSelectedIndexPathsWithObjects:(NSArray *)objects {
    [objects enumerateObjectsUsingBlock:^(id objectWeSearch, NSUInteger idx, BOOL *stopObjectFinding) {
        [self.sections enumerateKeysAndObjectsUsingBlock:^(id key, NSArray *sectionItems, BOOL *stopSectionEnumerating) {
            [sectionItems enumerateObjectsUsingBlock:^(id possibleObject, NSUInteger itemsIdx, BOOL *stopItemsEnumerating) {
                if (objectWeSearch == possibleObject) {
                    NSIndexPath *objectIndexPath = [NSIndexPath indexPathForRow:itemsIdx
                                                                      inSection:[self.sectionOrders indexOfObject:key]];

                    [self.selectedIndexPaths addObject:objectIndexPath];
                    
                    *stopItemsEnumerating = YES;
                    *stopSectionEnumerating = YES;
                }
            }];
        }];
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view data source


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self itemsFromSection:section] count];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sectionOrders objectAtIndex:section];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
        cell = [[self.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    id object = [self objectWithIndexPath:indexPath];
    
    if (![object isKindOfClass:[NSString class]]) {
        
        if (nil != self.textForObjectBlock) {
            object = self.textForObjectBlock(object);
        } else {
            object = nil;
        }
        
    }
    
    cell.textLabel.text = (NSString *)object;
    
    cell.accessoryType = [self.selectedIndexPaths containsObject:indexPath] ?
                         UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma Table view delegate


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *indexPathsToReload = [NSMutableArray arrayWithObject:indexPath];
    
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        if (YES == self.allowEmpty || (self.selectedIndexPaths.count > 1 && NO == self.allowEmpty) ) {
            [self.selectedIndexPaths removeObject:indexPath];
        }
    } else {
        if (NO == self.multiSelection) {
            [indexPathsToReload addObjectsFromArray:self.selectedIndexPaths];
            [self.selectedIndexPaths removeAllObjects];
        }
        
        [self.selectedIndexPaths addObject:indexPath];
    }
    
    [self.tableView reloadData];
    
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:self.scrollToRowScrollPositionOnSelect
                                  animated:(UITableViewScrollPositionNone != self.scrollToRowScrollPositionOnSelect) ? YES : NO];
    
//    [self.tableView reloadRowsAtIndexPaths:indexPathsToReload
//                          withRowAnimation:UITableViewRowAnimationNone];
    
    if (nil != self.selectBlock)
        self.selectBlock(self.selectedIndexPaths, self);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isSectionSelected:(NSInteger)section {
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        if (indexPath.section == section) {
            return YES;
        }
    }
    
    return NO;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)itemsFromSection:(NSInteger)section {
    NSString *sectionKey = [self.sectionOrders objectAtIndex:section];
    NSArray *items = [self.sections objectForKey:sectionKey];
    
    if (self.dropDownSection && NO == [self isSectionSelected:section]) {
        items = [NSArray arrayWithObject:[items objectAtIndex:0]];
    }
    
    return items;
}


@end
