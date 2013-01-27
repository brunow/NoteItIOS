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

#import <Foundation/Foundation.h>

typedef enum {
    TextViewManipulationStyleTypeBold,
    TextViewManipulationStyleTypeItalic,
    TextViewManipulationStyleTypeOrderedList,
    TextViewManipulationStyleTypeUnOrderedList
} TextViewManipulationStyleType;


@interface TextViewManipulation : NSObject

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) NSRange selectedRange;
@property (nonatomic, strong) NSString *text;

- (id)initWithTextView:(UITextView *)textView;

- (BOOL)hasStyleTypeOnSelectedRange:(TextViewManipulationStyleType)type;

- (void)removeStyleFromSelectedRange:(TextViewManipulationStyleType)type;

- (void)addStyleOnSelectedRange:(TextViewManipulationStyleType)type;

- (BOOL)hasStyleTextOnSelectedRange:(NSString *)text;

- (void)removeStyleTextFromSelectedRange:(NSString *)text;

- (void)addStyleTextOnSelectedRange:(NSString *)text;

- (void)deleteCurrentLine;

- (void)pushTitleLevelOnSelectedRange;

- (void)toogleOrderedList:(BOOL)ordered;

- (BOOL)isSelectedRangeOrderedList;

- (BOOL)isSelectedRangeUnOrderedList;

- (NSAttributedString *)attributedString;

// Text manipulations

- (NSUInteger)numberOfLines;

- (NSString *)lineWithNumber:(NSUInteger)line;

- (NSUInteger)lineNumberWithRange:(NSRange)range;

- (NSUInteger)lineNumberForSelection;

- (NSString *)textWithType:(TextViewManipulationStyleType)type;

- (NSRange)lineRangeWithRange:(NSRange)range;

- (NSRange)lineRangeForSelection;

- (NSString *)lineForSelection;

- (NSString *)lineWithRange:(NSRange)range;

- (void)replaceRange:(NSRange)range withText:(NSString *)text;

@end
