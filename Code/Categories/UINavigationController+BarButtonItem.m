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

#import "UINavigationController+BarButtonItem.h"

#import "SettingsViewController.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UINavigationController (BarButtonItem)


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dismissModalViewControllerAnimated {
    [self dismissViewControllerAnimated:YES completion:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIBarButtonItem *)doneBarButtonItemWithTarget:(id)target action:(SEL)action {
    return [UIBarButtonItem barButtonSystemItem:UIBarButtonSystemItemDone
                                         target:target
                                         action:action];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIBarButtonItem *)doneBarButtonItem {
    return [self doneBarButtonItemWithTarget:self
                                      action:@selector(dismissModalViewControllerAnimated)];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIBarButtonItem *)cancelBarButtonItem {
    return [UIBarButtonItem barButtonSystemItem:UIBarButtonSystemItemCancel
                                         target:self
                                         action:@selector(dismissModalViewControllerAnimated)];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIBarButtonItem *)settingsBarButtonItemWithTarget:(id)target action:(SEL)action {
    return [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                            style:UIBarButtonItemStyleBordered
                                           target:target
                                           action:action];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions



@end
