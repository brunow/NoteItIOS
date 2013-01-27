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

#import "FKValueViewField.h"


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FKValueViewField

@synthesize valueView = _valueView;


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.valueView.frame = CGRectMake(self.textLabel.frame.origin.x + self.textLabel.frame.size.width + 20, self.textLabel.frame.origin.y,
                                      self.contentView.frame.size.width - self.textLabel.frame.size.width - 40, self.textLabel.frame.size.height);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setValueView:(UIView *)valueView {
    if (_valueView != valueView) {
        [_valueView removeFromSuperview];
        _valueView = valueView;
        [self.contentView addSubview:_valueView];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (UITableViewCellStyle)cellStyle {
    return UITableViewCellStyleValue1;
}


@end
