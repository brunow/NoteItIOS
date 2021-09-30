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
//thank you

#import "BWManagedTableViewController.h"

@class CreateInPlaceView;

typedef void (^EditInPlaceBlock)(id object, NSString *text);

typedef void (^EditInPlaceToggleEditBlock)(BOOL isEdititng);

typedef void (^InPlaceCreateBlock)(NSString *text);

@interface NoteManagedTableViewController : BWManagedTableViewController <UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, copy) EditInPlaceBlock editBlock;
@property (nonatomic, copy) EditInPlaceToggleEditBlock toggleEditBlock;
@property (nonatomic, strong) NSIndexPath *scrollToIndexPath;
@property (nonatomic, copy) InPlaceCreateBlock creationBlock;
@property (nonatomic, strong) CreateInPlaceView *creationInPlaceView;
@property (nonatomic, assign, getter = isObservingScrollView) BOOL observingScrollView;


- (void)setuptEditInPlaceWithEditBlock:(EditInPlaceBlock)block
                       toggleEditBlock:(EditInPlaceToggleEditBlock)toggleEditBlock;

- (UIBarButtonItem *)editButton;

- (NSString *)titleIfNoItemInTableView;

- (void)didPressToggleEdit:(id)sender;

- (void)resignFirstResponder;

- (void)setuptInPlaceCreationWithCreationBlock:(InPlaceCreateBlock)block placeholder:(NSString *)placeholder;

- (void)unloadInPlaceCreation;

- (void)hideInPlaceCreateTextFieldAnimated:(BOOL)animated;

- (void)showInPlaceCreateTextFieldAnimated:(BOOL)animated;

@end
