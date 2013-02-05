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

#import "MarkdownTextViewManipulation.h"

#import "BOMarkdownParser.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation MarkdownTextViewManipulation


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        self.parser = [BOMarkdownParser parser];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Text manipulations


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSAttributedString *)attributedString {
    return [self.parser parseString:self.text];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isSelectedRangeOrderedList {
    NSString *line = [self lineForSelection];
    
    if (line.length < 3)
        return NO;
    
    NSString *firstLetter = [line substringToIndex:1];
    
    if ([firstLetter integerValue] == 0)
        return NO;
    
    NSString *secondPart = [line substringWithRange:NSMakeRange(1, 2)];
    
    return [secondPart isEqualToString:@". "];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isSelectedRangeUnOrderedList {
    NSString *line = [self lineForSelection];
    
    if (line.length < 2)
        return NO;
    
    NSString *firstLetter = [line substringToIndex:2];
    
    return [firstLetter isEqualToString:@"- "];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)hasStyleTextOnSelectedRange:(NSString *)text {
    if (0 == self.selectedRange.length)
        return NO;
    
    NSRange beforeRange = NSMakeRange(self.selectedRange.location - text.length, text.length);
    NSRange afterRange = NSMakeRange(self.selectedRange.location + self.selectedRange.length, text.length);
    
    // Check if not beyond of text
    if ((afterRange.location + afterRange.length) > self.text.length)
        return NO;
    
    NSString *beforeText = [self.text substringWithRange:beforeRange];
    NSString *afterText = [self.text substringWithRange:afterRange];
    
    BOOL beforeIncludeText = [text isEqualToString:beforeText];
    BOOL afterIncludeText = [text isEqualToString:afterText];
    
    return beforeIncludeText && afterIncludeText;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeStyleTextFromSelectedRange:(NSString *)text {
    if (0 == self.selectedRange.length)
        return;
    
    NSRange beforeManipulationSelectedRange = self.selectedRange;
    NSRange beforeRange = NSMakeRange(self.selectedRange.location - text.length, text.length);
    NSRange afterRange = NSMakeRange(self.selectedRange.location + self.selectedRange.length - text.length, text.length);
    NSString *textToRemoveStyle = [self lineForSelection];
    
    // Check if not beyond of text
    if ((afterRange.location + afterRange.length) > self.text.length)
        return;
    
    [self replaceRange:NSMakeRange(beforeRange.location, text.length * 2 + textToRemoveStyle.length)
              withText:textToRemoveStyle];
    
    self.selectedRange = NSMakeRange(beforeManipulationSelectedRange.location - text.length, beforeManipulationSelectedRange.length);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addStyleTextOnSelectedRange:(NSString *)text {
    if (0 == self.selectedRange.length) {
        [self replaceRange:NSMakeRange(self.selectedRange.location, 0) withText:text];
    } else {
        NSString *selectedText = [self lineWithRange:self.selectedRange];
        NSString *textToChange = [NSString stringWithFormat:@"%@%@%@", text, selectedText, text];
        [self replaceRange:self.selectedRange withText:textToChange];
    }
    
    self.selectedRange = NSMakeRange(self.selectedRange.location + text.length, self.selectedRange.length);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)pushTitleLevelOnSelectedRange {
    NSString *textToChange = self.textView.text;
    if (textToChange.length == 0) {
        return;
    }
    NSRange selectedRange = self.textView.selectedRange;
    NSRange toChangeRange = selectedRange;
    NSString *textToAdd = @"#";
    
    if (0 == selectedRange.length) {
        NSString *stringBeforeSelection = [textToChange substringToIndex:selectedRange.location];
        NSArray *beforeSelectionLines = [stringBeforeSelection componentsSeparatedByString:@"\n"];
        NSString *beforeTextSelection = [beforeSelectionLines lastObject];
        
        
        if (beforeTextSelection.length == 0) {
            toChangeRange.location = selectedRange.location;
        } else {
            if (![@"#" isEqualToString:[beforeTextSelection substringWithRange:NSMakeRange(0, 1)]])
                textToAdd = [textToAdd stringByAppendingString:@" "];
            
            toChangeRange.location = toChangeRange.location - beforeTextSelection.length;
        }
    } else {
        toChangeRange.length = 0;
    }
    
    textToChange = [textToChange stringByReplacingCharactersInRange:toChangeRange
                                                         withString:textToAdd];
    
    [self replaceRange:toChangeRange withText:textToAdd];
    
    NSString *afterSelectionText = [self.textView.text substringFromIndex:toChangeRange.location];
    NSString *firstLineText = [[afterSelectionText componentsSeparatedByString:@"\n"] firstObject];
    
    self.textView.selectedRange = NSMakeRange(toChangeRange.location + firstLineText.length, 0);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)toogleOrderedList:(BOOL)ordered {
    NSString *textToAdd = @"-";
    NSRange lineRange = [self lineRangeForSelection];
    NSString *line = [self lineForSelection];
    BOOL isAlreadyList = NO;

    if (YES == ordered) {
        textToAdd = [NSString stringWithFormat:@"%d.", [self lastOrderedListNum] + 1];
    }
    
    if (self.selectedRange.length == 0)
        textToAdd = [textToAdd stringByAppendingString:@" "];
    
    if (self.selectedRange.length == 0) {
        NSString *beginOfText = @"";
        
        if (line.length >= textToAdd.length) {
            beginOfText = [line substringWithRange:NSMakeRange(0, textToAdd.length)];
        }
        
        isAlreadyList = ([textToAdd isEqualToString:beginOfText]);
    }
    
    if (isAlreadyList) {
        line = [line stringByReplacingCharactersInRange:NSMakeRange(0, textToAdd.length) withString:@""];
    } else {
        line = [textToAdd stringByAppendingString:line];
    }
    
    [self replaceRange:lineRange withText:line];
    
    if (0 == self.selectedRange.length) {
        self.selectedRange = NSMakeRange(lineRange.location + line.length, 0);
    } else {
        self.selectedRange = NSMakeRange(self.selectedRange.location + textToAdd.length, self.selectedRange.length);
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)deleteCurrentLine {
    NSRange lineRange = [self lineRangeForSelection];
    [self replaceRange:lineRange withText:@""];
    self.selectedRange = NSMakeRange(lineRange.location, 0);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)lineBeforeLineRange:(NSRange)range {
    NSString *beforeLineText = [self.text substringToIndex:range.location];
    NSArray *beforeLines = [beforeLineText componentsSeparatedByString:@"\n"];
    
    if (beforeLines.count >= 2) {
        return [beforeLines objectAtIndex:beforeLines.count - 2];
    }
    
    return nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSUInteger)lastOrderedListNum {
    NSString *previousLine = [self lineBeforeLineRange:[self lineRangeForSelection]];
        
    if (0 == [previousLine length])
        return 0;
    
    NSString *firstLetter = [previousLine substringToIndex:1];
    return [firstLetter integerValue];
}


@end
