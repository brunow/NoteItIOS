//
// Created by Bruno Wernimont on 2013
// Copyright 2013 NoteIT
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

#import "ListsTableViewController.h"
#import "UINavigationController+BarButtonItem.h"
#import "BWBackendObjectUpdateManager.h"
#import "ListsNotesSplitViewController.h"
#import "BlocksKit.h"
#import "NSDate+RailsDateFormat.h"
#import "CoreData+MagicalRecord.h"
#import "NSManagedObject+FindOrCreate.h"
#import "Underscore.h"
#import "SSTextField.h"

#import "List.h"
#import "EditableCellView.h"
#import "NotesTableViewController.h"
#import "SettingsViewController.h"
#import "HttpClient.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ListsTableViewController ()

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ListsTableViewController


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [self.navigationController settingsBarButtonItemWithTarget:self
                                                                                                action:@selector(didPressSettings:)];
    
    __weak ListsTableViewController *weakRef = self;
    [self setuptInPlaceCreationWithCreationBlock:^(NSString *text) {
        List *list = [List createEntity];
        list.title = text;
        
        [list insertObjectInObjects:[weakRef.tableModel.fetchedResultsController fetchedObjects]
                         atPosition:NSManagedObjectSortablePositionBottom];
        
        [list setObjectNeedToBeSynced:YES];
        [list.managedObjectContext saveNestedContexts];
        
    } placeholder:@"Create new list"];
    
    [self setuptEditInPlaceWithEditBlock:^(List *list, NSString *text) {
        list.title = text;
        [list setObjectNeedToBeSynced:YES];
        [list.managedObjectContext saveNestedContexts];
    } toggleEditBlock:^(BOOL isEdititng) {
        [weakRef hideInPlaceCreateTextFieldAnimated:YES];
        
    }];

    self.title = @"Lists";
    
    if (!BKIsPad()) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-bar-logo.png"]];
    }
    
    if (BKIsPad() && [self.fetchedResultsController.fetchedObjects count] > 0) {
        NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        List *list = [self.fetchedResultsController objectAtIndexPath:firstObjectIndexPath];
        self.clearsSelectionOnViewWillAppear = NO;
        
        NotesTableViewController *notesVC = [[ListsNotesSplitViewController sharedSplitViewController] notesViewController];
        notesVC.list = list;
        
        [self.tableView selectRowAtIndexPath:firstObjectIndexPath
                                    animated:NO
                              scrollPosition:UITableViewRowAnimationNone];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[self.fetchedResultsController fetchedObjects] count] > 0) {
        [self hideInPlaceCreateTextFieldAnimated:NO];
    } else {
        [self showInPlaceCreateTextFieldAnimated:NO];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self hideInPlaceCreateTextFieldAnimated:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)titleIfNoItemInTableView {
    return @"No lists";
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Resource


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)fetchResource {
    NSDictionary *params = nil;
    
    NSDate *lastUpdatedAt = [List lastUpdateAt];
    if (nil != lastUpdatedAt) {
        params = @{
            @"last_updated_at" : [lastUpdatedAt railsFormatDate]
        };
    }
    
    [[HttpClient sharedClient] allObjects:[List class]
                                   params:params
                                  success:nil
                                  failure:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPressSettings:(id)sender {
    [self resignFirstResponder];
    
    SettingsViewController *vc = [[SettingsViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    if (BKIsPad()) {
        nc.modalPresentationStyle = UIModalPresentationPageSheet;
    }
    
    [self presentViewController:nc animated:YES completion:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectObject:(id)object {
    [self resignFirstResponder];
    
    if (BKIsPad()) {
        NotesTableViewController *notesVC = [[ListsNotesSplitViewController sharedSplitViewController] notesViewController];
        notesVC.list = object;
    } else {
        [self.navigationController pushViewControllerWithBlock:^UIViewController *{
            return [[NotesTableViewController alloc] initWithList:object];
        } animated:YES];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Fetched


////////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)entityClass {
    return [List class];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSSortDescriptor *)sortDescriptor {
    return [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSPredicate *)predicate {
    return [NSPredicate predicateWithFormat:@"deletedAt == NULL"];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TableModel


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupCellMapping {
    [super setupCellMapping];
    
    __weak ListsTableViewController *weakRef = self;
    [TKCellMapping mappingForObjectClass:[List class] block:^(TKCellMapping *mapping) {
        [mapping mapKeyPath:@"title" toAttribute:@"textField.text"];
        
        [mapping commitEditingStyleWithBlock:^(List *object, NSIndexPath *indexPath, UITableViewCellEditingStyle editingStyle) {
            [object markAsDeleted];
            [object setObjectNeedToBeSynced:YES];
            [object.managedObjectContext saveNestedContexts];
        }];
        
        [mapping editingStyleWithBlock:^UITableViewCellEditingStyle(id object, NSIndexPath *indexPath) {
            return UITableViewCellEditingStyleDelete;
        }];
        
        [mapping onSelectRowWithBlock:^(UITableViewCell *cell, id list, NSIndexPath *indexPath) {
            [weakRef didSelectObject:list];
        }];
        
        [mapping canMoveObjectWithBlock:^BOOL(id object, NSIndexPath *indexPath) {
            return NO;
        }];
        
        [mapping canEditObjectWithBlock:^BOOL(id object, NSIndexPath *indexPath, UITableViewCellEditingStyle editingStyle) {
            return YES;
        }];
        
        [mapping moveObjectWithBlock:^(id object, NSIndexPath *sourceIndexPath, NSIndexPath *toIndexPath) {
            NSArray *objects = [weakRef.tableModel.fetchedResultsController fetchedObjects];
            NSArray *sortedObjects = [NSManagedObject sortObjects:objects toPosition:toIndexPath.row withObject:object];
            
            [sortedObjects each:^(NSManagedObject *object) {
                [object setObjectNeedToBeSynced:YES];
                [object.managedObjectContext saveNestedContexts];
            }];
        }];
        
        [mapping willDisplayCellWithBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
            [[(EditableCellView *)cell textField] setDelegate:self];
        }];
        
        [mapping mapObjectToCellClass:[EditableCellView class]];
        [self.tableModel registerMapping:mapping];
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIPopoverControllerDelegate


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.settingsPopover = nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


@end
