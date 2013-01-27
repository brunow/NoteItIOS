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

#import <UIKit/UIKit.h>

typedef enum {
    ToolbarInputAccessoryViewCursorMoveDirectionLeft,
    ToolbarInputAccessoryViewCursorMoveDirectionRight
} ToolbarInputAccessoryViewCursorMoveDirection;

typedef enum {
    ToolbarInputAccessoryViewListTypeEditing,
    ToolbarInputAccessoryViewListTypeList,
    ToolbarInputAccessoryViewListTypeMove
} ToolbarInputAccessoryViewListType;


@protocol ToolbarInputAccessoryViewDelegate;

@interface ToolbarInputAccessoryView : UIView

@property (nonatomic, weak) id<ToolbarInputAccessoryViewDelegate> delegate;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) ToolbarInputAccessoryViewListType listType;
@property (nonatomic, strong) UIButton *boldBtn;
@property (nonatomic, strong) UIButton *italicBtn;
@property (nonatomic, strong) UIButton *orderedListBtn;
@property (nonatomic, strong) UIButton *unOrderedListBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *titleBtn;

@end

@protocol ToolbarInputAccessoryViewDelegate <NSObject>

@required

- (void)toolbarInputAccessoryView:(ToolbarInputAccessoryView *)toolbarInputTextView
                  didSelectDelete:(id)sender;

- (void)toolbarInputAccessoryView:(ToolbarInputAccessoryView *)toolbarInputTextView
                didSelectTitleize:(id)sender;

- (void)toolbarInputAccessoryView:(ToolbarInputAccessoryView *)toolbarInputTextView
                 didSelectBoldize:(id)sender;

- (void)toolbarInputAccessoryView:(ToolbarInputAccessoryView *)toolbarInputTextView
                 didSelectItalize:(id)sender;

- (void)toolbarInputAccessoryView:(ToolbarInputAccessoryView *)toolbarInputTextView
                    didSelectList:(id)sender
                          ordered:(BOOL)ordered;

- (void)toolbarInputAccessoryView:(ToolbarInputAccessoryView *)toolbarInputTextView
              didSelectMoveCursor:(id)sender
                    moveDirection:(ToolbarInputAccessoryViewCursorMoveDirection)direction;

@end