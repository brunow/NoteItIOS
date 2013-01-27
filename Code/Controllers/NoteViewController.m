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

#import "NoteViewController.h"

#import "UINavigationController+BarButtonItem.h"
#import "BWBackendObjectUpdateManager.h"
#import "NimbusAttributedLabel.h"
#import "NSString+NimbusCore.h"
#import "CoreData+MagicalRecord.h"
#import "NSManagedObject+FindOrCreate.h"
#import "BaseKitCore.h"

#import "ToolbarInputAccessoryView.h"
#import "Note.h"
#import "Settings.h"
#import "UndoRedoView.h"
#import "AttributeStringTextViewManipulation.h"
#import "MarkdownTextViewManipulation.h"

#define EMPTY_CONTENT_MARKDOWN @"You don't have content yet"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface NoteViewController ()

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NoteViewController


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNote:(Note *)note {
    self = [super init];
    if (self) {
        self.note = note;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.undoRedoView = [[UndoRedoView alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
    
    [self.undoRedoView.undoBtn addTarget:self
                                  action:@selector(didPressUndo:)
                        forControlEvents:UIControlEventTouchUpInside];
    
    [self.undoRedoView.redoBtn addTarget:self
                                  action:@selector(didPressRedo:)
                        forControlEvents:UIControlEventTouchUpInside];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-textview.png"]];
    self.textView.allowsEditingTextAttributes = ![Settings isPreferingMarkdownSyntax];
    self.textView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
    [self.view addSubview:self.textView];
    
    self.scrollableContent = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollableContent.autoresizingMask = self.view.autoresizingMask;
    self.scrollableContent.backgroundColor = [UIColor whiteColor];
    self.scrollableContent.bounces = YES;
    self.scrollableContent.alwaysBounceVertical = YES;
    self.scrollableContent.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    [self.view addSubview:self.scrollableContent];
    
    self.textLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.numberOfLines = 0;
    [self.scrollableContent addSubview:self.textLabel];
    
    self.toolbarAccesoryView = [[ToolbarInputAccessoryView alloc] init];
    self.toolbarAccesoryView.delegate = self;
    
    if ([Settings showTextToolbarAccesory])
        self.textView.inputAccessoryView = self.toolbarAccesoryView;

    if ([self.navigationController.viewControllers count] == 1) {
        self.navigationItem.leftBarButtonItem = [self.navigationController doneBarButtonItem];
    }

    self.navigationItem.rightBarButtonItem = [self editButton];
    
    if ([Settings isPreferingMarkdownSyntax]) {
        self.textView.text = self.note.content;
        self.textManipulation = [[MarkdownTextViewManipulation alloc] initWithTextView:self.textView];
    } else {
        self.textManipulation = [[AttributeStringTextViewManipulation alloc] initWithTextView:self.textView
                                                                      mutableAttributedString:self.mutableAttributedText];
    }
    
    _isEditing = NO;
    
    [self loadReadOnlyText];
    
    self.title = self.note.title;    
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.textView resignFirstResponder];
    
    [self saveObject];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self layoutTextLabelWithInterfaceOrientation:toInterfaceOrientation duration:duration];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutTextLabelWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                                       duration:(NSTimeInterval)duration {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat contentInset = 5;
    
    CGFloat width = screenWidth - contentInset * 2;
    
    CGFloat height = [self.textLabel.text heightWithFont:self.textLabel.font
                                      constrainedToWidth:width
                                           lineBreakMode:self.textLabel.lineBreakMode];
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        CGFloat temp = width;
        width = height;
        height = temp;
    }
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        width += contentInset;
    } else {
        height -= contentInset;
    }
    
    self.textLabel.font = [UIFont systemFontOfSize:UIInterfaceOrientationIsLandscape(interfaceOrientation) ? 17 : 16];
    
    self.textLabel.frame = CGRectMake(contentInset,
                                      contentInset,
                                      width,
                                      height);
    
    [self.scrollableContent setContentSize:CGSizeMake(screenWidth - self.scrollableContent.contentInset.left - self.scrollableContent.contentInset.right,
                                                      height - self.scrollableContent.contentInset.top - self.scrollableContent.contentInset.bottom)];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Notifications


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardFrameWillChange {
    [super keyboardFrameWillChange];
    
    self.textView.frame = self.currentViewBounds;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITextViewDelegate


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    
    return YES;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidChange:(UITextView *)textView {
    [self updateToolbarButton];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidChangeSelection:(UITextView *)textView {
    [self updateToolbarButton];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidBeginEditing:(UITextView *)textView {
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (YES == self.isEditing)
        [self toggleEditing];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPressUndo:(id)sender {
    [[self.textView undoManager] undo];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPressRedo:(id)sender {
    [[self.textView undoManager] redo];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark ToolbarInputAccessoryView


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)toolbarInputAccessoryView:(ToolbarInputAccessoryView *)toolbarInputTextView
                  didSelectDelete:(id)sender {

    [self.textManipulation deleteCurrentLine];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)toolbarInputAccessoryView:(ToolbarInputAccessoryView *)toolbarInputTextView
                didSelectTitleize:(id)sender {
    
    [self.textManipulation pushTitleLevelOnSelectedRange];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)toolbarInputAccessoryView:(ToolbarInputAccessoryView *)toolbarInputTextView
                 didSelectBoldize:(id)sender {
    
    TextViewManipulationStyleType type = TextViewManipulationStyleTypeBold;
    
    if ([self.textManipulation hasStyleTypeOnSelectedRange:type]) {
        [self.textManipulation removeStyleFromSelectedRange:type];
    } else {
        [self.textManipulation addStyleOnSelectedRange:type];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)toolbarInputAccessoryView:(ToolbarInputAccessoryView *)toolbarInputTextView
                 didSelectItalize:(id)sender {
    
    TextViewManipulationStyleType type = TextViewManipulationStyleTypeItalic;
    
    if ([self.textManipulation hasStyleTypeOnSelectedRange:type]) {
        [self.textManipulation removeStyleFromSelectedRange:type];
    } else {
        [self.textManipulation addStyleOnSelectedRange:type];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)toolbarInputAccessoryView:(ToolbarInputAccessoryView *)toolbarInputTextView
                    didSelectList:(id)sender
                          ordered:(BOOL)ordered {
    
    [self.textManipulation toogleOrderedList:ordered];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)toolbarInputAccessoryView:(ToolbarInputAccessoryView *)toolbarInputTextView
              didSelectMoveCursor:(id)sender
                    moveDirection:(ToolbarInputAccessoryViewCursorMoveDirection)direction {
    
    NSRange range = self.textView.selectedRange;
    
    int directionNumber = (ToolbarInputAccessoryViewCursorMoveDirectionLeft == direction) ? -1 : 1;
    range.location += directionNumber;
    
    if (range.length > 0) {
        range.length += direction;
    }
    
    self.textView.selectedRange = range;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateToolbarButton {
    [BKOperationHelper performBlockInMainThread:^{
        BOOL isSelectionBold = [self.textManipulation hasStyleTypeOnSelectedRange:TextViewManipulationStyleTypeBold];
        BOOL isSelectionItalic = [self.textManipulation hasStyleTypeOnSelectedRange:TextViewManipulationStyleTypeItalic];
        BOOL isOrderedList = [self.textManipulation isSelectedRangeOrderedList];
        BOOL isUnOrderedList = [self.textManipulation isSelectedRangeUnOrderedList];
        
        [self.toolbarAccesoryView.boldBtn setSelected:isSelectionBold];
        [self.toolbarAccesoryView.italicBtn setSelected:isSelectionItalic];
        [self.toolbarAccesoryView.orderedListBtn setSelected:isOrderedList];
        [self.toolbarAccesoryView.unOrderedListBtn setSelected:isUnOrderedList];
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)saveObject {
    if ([self.note hasChanges]) {
        [self.note setObjectNeedToBeSynced:YES];
        [self.note.managedObjectContext saveNestedContexts];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIBarButtonItem *)editButton {
    return [UIBarButtonItem barButtonSystemItem:(_isEditing ? UIBarButtonSystemItemDone : UIBarButtonSystemItemEdit)
                                         target:self
                                         action:@selector(toggleEditing)];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadReadOnlyText {
    if ([Settings isPreferingMarkdownSyntax]) {
        self.textLabel.attributedText = [self.textManipulation attributedString];
    } else {
        self.textLabel.attributedText = nil;
    }
    
    [self layoutTextLabelWithInterfaceOrientation:self.interfaceOrientation duration:0];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadEditableText {
    self.textView.text = self.note.content;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)toggleEditing {
    _isEditing = !_isEditing;
    
    self.navigationItem.rightBarButtonItem = [self editButton];
    
    if (_isEditing) {
        self.navigationItem.titleView = self.undoRedoView;
        self.textView.alpha = 0;
        [self loadEditableText];
        [self.textView becomeFirstResponder];
    } else {
        [self.textView resignFirstResponder];
        self.navigationItem.titleView = nil;
        self.note.content = self.textView.text;
        [self saveObject];
        self.scrollableContent.alpha = 0;
        [self loadReadOnlyText];
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        if (_isEditing) {
            self.scrollableContent.alpha = 0;
            self.textView.alpha = 1;
        } else {
            self.textView.alpha = 0;
            self.scrollableContent.alpha = 1;
        }
    }];
}


@end
