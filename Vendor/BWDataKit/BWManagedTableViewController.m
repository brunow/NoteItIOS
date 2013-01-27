//
// Created by Bruno Wernimont on 2013
// Copyright 2012 BWDataKit
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
// Inspired by the great https://github.com/soffes/ssdatakit
//

#import "BWManagedTableViewController.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BWManagedTableViewController ()

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BWManagedTableViewController


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    return [self initWithStyle:UITableViewStylePlain];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super init];
    if (self) {
        _style = style;
        self.clearsSelectionOnViewWillAppear = YES;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:_style];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shouldResiszeView = YES;
    
    if (YES == [self createTableModel]) {
        [self _setupCellMapping];
        [self setupCellMapping];
        self.tableModel.fetchedResultsController = [self fetchedResultsController];
        [self.tableModel loadItems];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (YES == self.clearsSelectionOnViewWillAppear) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectObject:(id)object {
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Notification


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardFrameWillChange {
    [super keyboardFrameWillChange];

    if (YES == self.shouldResiszeView) {
        // Don't animate hidding
        if (NO == self.keyboardHidden) {
            [UIView animateWithDuration:0.3 animations:^{
                self.tableView.frame = self.currentViewBounds;
            }];
        } else {
            self.tableView.frame = self.currentViewBounds;
        }
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIScrollViewDelegate


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TableKit


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)createTableModel {
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupCellMapping {
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)_setupCellMapping {
    self.tableModel = [TKManagedTableModel tableModelForTableView:self.tableView];
    self.tableModel.fetchedResultsControllerDelegate = self;
    self.tableModel.delegate = self;
    self.tableView.delegate = self.tableModel;
    self.tableView.dataSource = self.tableModel;
}


@end
