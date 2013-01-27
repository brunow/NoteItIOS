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

@class Note;

#import "ToolbarInputAccessoryView.h"
#import "BWManagedViewController.h"

@class UndoRedoView;
@class NIAttributedLabel;
@class TextViewManipulation;

@interface NoteViewController : BWManagedViewController <
UITextViewDelegate, ToolbarInputAccessoryViewDelegate> {
    BOOL _isEditing;
}

@property (nonatomic, strong) Note *note;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) ToolbarInputAccessoryView *toolbarAccesoryView;
@property (nonatomic, strong) UndoRedoView *undoRedoView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIScrollView *scrollableContent;
@property (nonatomic, strong) TextViewManipulation *textManipulation;
@property (nonatomic, strong) NSMutableAttributedString *mutableAttributedText;

- (id)initWithNote:(Note *)note;

@end
