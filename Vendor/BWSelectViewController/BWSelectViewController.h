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

#import <UIKit/UIKit.h>

@class BWSelectViewController;

typedef void(^BWSelectViewControllerDidSelectBlock)(NSArray *selectedIndexPaths, BWSelectViewController *controller);

typedef NSString *(^BWSelectViewControllerTextForObjectBlock)(id object);

@interface BWSelectViewController : UITableViewController

@property (nonatomic, copy) NSDictionary *sections;
@property (nonatomic, strong) BWSelectViewControllerDidSelectBlock selectBlock;
@property (nonatomic, readonly) NSMutableArray *selectedIndexPaths;
@property (nonatomic, assign) BOOL multiSelection;
@property (nonatomic, assign) Class cellClass;
@property (nonatomic, assign) BOOL allowEmpty;
@property (nonatomic, strong) NSArray *sectionOrders;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) BOOL dropDownSection;
@property (nonatomic, copy) BWSelectViewControllerTextForObjectBlock textForObjectBlock;
@property (nonatomic, assign) UITableViewScrollPosition scrollToRowScrollPositionOnSelect;

- (id)initWithItems:(NSArray *)items
     multiselection:(BOOL)multiSelection
         allowEmpty:(BOOL)allowEmpty
      selectedItems:(NSArray *)selectedItems
        selectBlock:(BWSelectViewControllerDidSelectBlock)selectBlock;

- (id)initWithSections:(NSDictionary *)sections
                orders:(NSArray *)orders
        multiselection:(BOOL)multiSelection
            allowEmpty:(BOOL)allowEmpty
         selectedItems:(NSArray *)selectedItems
           selectBlock:(BWSelectViewControllerDidSelectBlock)selectBlock;

- (void)setDidSelectBlock:(BWSelectViewControllerDidSelectBlock)didSelectBlock;

- (void)setSlectedIndexPaths:(NSArray *)selectedIndexPaths;

- (void)setSections:(NSDictionary *)sections orders:(NSArray *)orders;

- (void)setTextForObjectBlock:(BWSelectViewControllerTextForObjectBlock)textForObjectBlock;

- (id)objectWithIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)selectedObjects;

- (void)setSelectedIndexPathsWithObject:(id)object;

- (void)setSelectedIndexPathsWithObjects:(NSArray *)objects;

@end
