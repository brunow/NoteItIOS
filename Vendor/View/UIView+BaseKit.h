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

#import <UIKit/UIKit.h>

@interface UIView (BaseKit)

- (UIView *)findFirstResponder;

- (id)findFirstTextField;

- (NSArray *)findTextFields;

/**
 Set alpha value of the receiver to 1
 */
- (void)show;

/**
 Set alpha value of the receiver to 0
 */
- (void)hide;

/**
 Toggle alpha value or the receiver between 0 and 1
 */
- (void)toggle;

/**
 Receiver will fade in
 
 @param duration of the animation
 */
- (void)fadeInWithDuration:(NSTimeInterval)duration;

/**
 Receiver will fade out
 
 @param duration of the animation
 */
- (void)fadeOutWithDuration:(NSTimeInterval)duration;

/**
 Receiver will fade out and remove the view from its superview after animation ended
 
 @param duration of the animation
 */
- (void)fadeOutAndRemoveFromSuperviewWithDuration:(NSTimeInterval)duration;

@end
