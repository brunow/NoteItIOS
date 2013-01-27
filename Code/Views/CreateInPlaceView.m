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

#import "CreateInPlaceView.h"

#import "SSTextField.h"

#define LINE_HEIGHT 2
#define HORIZONTAL_SPACING 5
#define VERTICAL_SPACING 6

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CreateInPlaceView


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-toolbar.png"]];
        
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"btn-textfield-add.png"]
                               forState:UIControlStateNormal];
        
        [self.addBtn sizeToFit];
        self.addBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        self.addBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - self.addBtn.frame.size.width - HORIZONTAL_SPACING,
                                       VERTICAL_SPACING + 1,
                                       CGRectGetWidth(self.addBtn.frame),
                                       CGRectGetHeight(self.addBtn.frame));
        
        self.textField = [[SSTextField alloc] initWithFrame:CGRectZero];
        
        self.textField.frame = CGRectMake(HORIZONTAL_SPACING,
                                          VERTICAL_SPACING,
                                          CGRectGetWidth(self.frame) - CGRectGetWidth(self.addBtn.frame) - HORIZONTAL_SPACING * 3,
                                          33);
        
        self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.textField.borderStyle = UITextBorderStyleNone;
        self.textField.textColor = BK_RGB_COLOR(219, 205, 180);
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.textField.background = [[UIImage imageNamed:@"bg-textfield.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 11, 15, 11)];
        [(SSTextField *)self.textField setTextEdgeInsets:UIEdgeInsetsMake(6, 15, 8, 15)];
        [(SSTextField *)self.textField setClearButtonEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -2)];
        [(SSTextField *)self.textField setPlaceholderTextColor:BK_RGB_COLOR(228, 216, 195)];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - LINE_HEIGHT, CGRectGetWidth(self.frame), LINE_HEIGHT)];
        self.lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hr-line.png"]];
        self.lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:self.textField];
        [self addSubview:self.addBtn];
        [self addSubview:self.lineView];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}


@end
