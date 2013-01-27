//
// Created by Bruno Wernimont on 2012
// Copyright 2012 BaseKit
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

#import "UIView+BaseKit.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface UIView (Private)

- (NSMutableArray *)findTextFieldsAndStopAtFirst:(BOOL)stopAtFirst;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIView (BaseKit)


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)findFirstResponder {
    if ([self isFirstResponder]) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        
        if (nil != firstResponder) {
            return firstResponder;
        }
    }
    
    return nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)findFirstTextField {
    NSArray *fields = [self findTextFieldsAndStopAtFirst:YES];
    if (fields.count == 1) {
        return [fields lastObject];
    }
    return nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)findTextFields {
    return [self findTextFieldsAndStopAtFirst:NO];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)show {
    self.alpha = 1;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)hide {
    self.alpha = 0;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)toggle {
    self.alpha = (self.alpha > 0) ? 0 : 1;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)fadeInWithDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)fadeOutWithDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)fadeOutAndRemoveFromSuperviewWithDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSMutableArray *)findTextFieldsAndStopAtFirst:(BOOL)stopAtFirst {
    NSMutableArray *fields = [[NSMutableArray alloc] init];
    
    [self.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        if (YES == stopAtFirst && 1 == fields.count) {
            *stop = YES;
        }
        
        if ([subView isKindOfClass:[UITextField class]] || [subView isKindOfClass:[UITextView class]]) {
            [fields addObject:subView];
        } else {
            NSArray *fieldsFounded = [subView findTextFieldsAndStopAtFirst:stopAtFirst];
            [fields addObjectsFromArray:fieldsFounded];
        }
    }];
    
    return fields;
}


@end
