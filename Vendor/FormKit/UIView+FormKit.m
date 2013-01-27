//
// Created by Bruno Wernimont on 2012
// Copyright 2012 FormKit
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

#import "UIView+FormKit.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface UIView (Private)

- (NSMutableArray *)fk_findTextFieldsAndStopAtFirst:(BOOL)stopAtFirst;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIView (FormKit)


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)fk_findFirstResponder {
    if ([self isFirstResponder]) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView fk_findFirstResponder];
        
        if (nil != firstResponder) {
            return firstResponder;
        }
    }
    
    return nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)fk_findFirstTextField {
    NSArray *fields = [self fk_findTextFieldsAndStopAtFirst:YES];
    if (fields.count == 1) {
        return [fields lastObject];
    }
    return nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)fk_findTextFields {
    return [self fk_findTextFieldsAndStopAtFirst:NO];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableArray *)fk_findTextFieldsAndStopAtFirst:(BOOL)stopAtFirst {
    NSMutableArray *fields = [[NSMutableArray alloc] init];
    
    [self.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        if (YES == stopAtFirst && 1 == fields.count) {
            *stop = YES;
        }
        
        if ([subView isKindOfClass:[UITextField class]] || [subView isKindOfClass:[UITextView class]]) {
            [fields addObject:subView];
        } else {
            NSArray *fieldsFounded = [subView fk_findTextFieldsAndStopAtFirst:stopAtFirst];
            [fields addObjectsFromArray:fieldsFounded];
        }
    }];
    
    return fields;
}


@end
