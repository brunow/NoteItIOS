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

typedef id(^TKCellValueBlock)(id value);

typedef id(^TKCellObjectBlock)(id value, id object);

typedef Class(^BKCellObjectRetClass)(id obj);

typedef void(^TKTableViewCellSelectionBlock)(UITableViewCell *cell, id object, NSIndexPath *indexPath);

typedef CGFloat(^TKCellRowHeightBlock)(Class cellClass, id object, NSIndexPath *indexPath);

typedef id(^TKObjectForRowAtIndexPathBlock)(NSIndexPath *indexPath);

typedef void(^TKTableViewCellWillDisplayCellBlock)(UITableViewCell *cell, id object, NSIndexPath *indexPath);

typedef void(^TKTableViewCommitEditingStyleBlock)(id object, NSIndexPath *indexPath, UITableViewCellEditingStyle editingStyle);

typedef UITableViewCellEditingStyle(^TKTableViewEditingStyleBlock)(id object, NSIndexPath *indexPath);

typedef UIView *(^TKTableViewForHeaderInSectionViewBlock)(UITableView *tableView, NSInteger section, NSString *title);

typedef BOOL(^TKTableViewCanMoveObjectBlock)(id object, NSIndexPath *indexPath);

typedef void(^TKTableViewMoveObjectBlock)(id object, NSIndexPath *sourceIndexPath, NSIndexPath *toIndexPath);

typedef BOOL(^TKTableViewCanEditObjectBlock)(id object, NSIndexPath *indexPath, UITableViewCellEditingStyle editingStyle);
