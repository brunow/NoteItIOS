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

#import "NotesTableViewController.h"

#import "BWBackendObjectUpdateManager.h"
#import "BlocksKit.h"
#import "NSDate+RailsDateFormat.h"
#import "CoreData+MagicalRecord.h"
#import "NSManagedObject+FindOrCreate.h"
#import "SSTextField.h"

#import "ListsNotesSplitViewController.h"
#import "List.h"
#import "Note.h"
#import "EditableCellView.h"
#import "NoteViewController.h"
#import "HttpClient.h"

#define SELECTED_LIST_CHANGE_OBSERVER_IDENTIFIER @"LIST_OBSERVER_IDENTIFIER"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NotesTableViewController ()

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NotesTableViewController


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithList:(List *)list {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.list = list;
        self.title = self.list.title;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak NotesTableViewController *weakRef = self;
    
    [self setuptInPlaceCreationWithCreationBlock:^(NSString *text) {
        Note *note = [Note createEntity];
        note.title = text;
        [weakRef.list addNotesObject:note];
        
        [note insertObjectInObjects:[weakRef.tableModel.fetchedResultsController fetchedObjects]
                         atPosition:NSManagedObjectSortablePositionBottom];
        
        [note setObjectNeedToBeSynced:YES];
        [note.managedObjectContext saveNestedContexts];
        
    } placeholder:@"Create new note"];
    
    [self setuptEditInPlaceWithEditBlock:^(Note *note, NSString *text) {
        note.title = text;
        [note setObjectNeedToBeSynced:YES];
        [note.managedObjectContext saveNestedContexts];
        
    } toggleEditBlock:^(BOOL isEdititng) {
        [weakRef hideInPlaceCreateTextFieldAnimated:YES];
    }];
    
    if (BKIsPad()) {
        __weak NotesTableViewController *weakRef = self;
        
        [self addObserverForKeyPath:@"list"
                         identifier:SELECTED_LIST_CHANGE_OBSERVER_IDENTIFIER
                            options:NSKeyValueChangeReplacement
                               task:^(id obj, NSDictionary *change) {

                                   weakRef.fetchedResultsController = nil;
                                   weakRef.tableModel.fetchedResultsController = [weakRef fetchedResultsController];
                                   [weakRef.tableModel loadItems];
                                   [weakRef.tableView reloadData];
                                   [weakRef fetchResource];
                               }];
    }
    
    if (BKIsPad()) {
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav-bar-logo.png"]];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload {
    [super viewDidUnload];
    
    [self removeObserversWithIdentifier:SELECTED_LIST_CHANGE_OBSERVER_IDENTIFIER];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hideInPlaceCreateTextFieldAnimated:NO];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)titleIfNoItemInTableView {
    return @"No notes";
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Resources


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)fetchResource {
    NSArray *notes = [Note findAllSortedBy:@"updatedAt"
                                 ascending:YES
                             withPredicate:[NSPredicate predicateWithFormat:@"list == %@", self.list]];
    
    NSDictionary *params = nil;

    if (notes.count > 0) {
        Note *lastUpdatedNote = [notes lastObject];
        
        if (nil != lastUpdatedNote.updatedAt) {
            params = @{
                @"last_updated_at" : [lastUpdatedNote.updatedAt railsFormatDate]
            };
        }
    }
    
    [[HttpClient sharedClient] allObjects:[Note class]
                               fromObject:self.list
                                   params:params
                                  success:nil
                                  failure:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectObject:(id)object {
    [self resignFirstResponder];
    
    if (BKIsPad()) {
        [self presentModalViewControllerWithBlock:^UIViewController *{
            return [[NoteViewController alloc] initWithNote:object];
        } animated:YES];
    } else {
        [self.navigationController pushViewControllerWithBlock:^UIViewController *{
            return [[NoteViewController alloc] initWithNote:object];
        } animated:YES];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Fetched


////////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)entityClass {
    return [Note class];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSSortDescriptor *)sortDescriptor {
    return [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSPredicate *)predicate {
    return [NSPredicate predicateWithFormat:@"list == %@ AND deletedAt == NULL", self.list];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TableModel


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupCellMapping {
    [super setupCellMapping];
    
    __weak NotesTableViewController *weakRef = self;
    
    [TKCellMapping mappingForObjectClass:[Note class] block:^(TKCellMapping *mapping) {
        [mapping mapKeyPath:@"title" toAttribute:@"textField.text"];
        
        [mapping commitEditingStyleWithBlock:^(Note *object, NSIndexPath *indexPath, UITableViewCellEditingStyle editingStyle) {
            [object markAsDeleted];
            [object setObjectNeedToBeSynced:YES];
            [object.managedObjectContext saveNestedContexts];
        }];
        
        [mapping editingStyleWithBlock:^UITableViewCellEditingStyle(id object, NSIndexPath *indexPath) {
            return UITableViewCellEditingStyleDelete;
        }];
        
        [mapping onSelectRowWithBlock:^(UITableViewCell *cell, id note, NSIndexPath *indexPath) {
            [weakRef didSelectObject:note];
        }];
        
        [mapping canMoveObjectWithBlock:^BOOL(id object, NSIndexPath *indexPath) {
            return NO;
        }];
        
        [mapping canEditObjectWithBlock:^BOOL(id object, NSIndexPath *indexPath, UITableViewCellEditingStyle editingStyle) {
            return YES;
        }];
        
        [mapping moveObjectWithBlock:^(id object, NSIndexPath *sourceIndexPath, NSIndexPath *toIndexPath) {
            
        }];
        
        [mapping willDisplayCellWithBlock:^(UITableViewCell *cell, id object, NSIndexPath *indexPath) {
            [[(EditableCellView *)cell textField] setDelegate:self];
        }];
        
        [mapping mapObjectToCellClass:[EditableCellView class]];
        [self.tableModel registerMapping:mapping];
    }];
}


@end
