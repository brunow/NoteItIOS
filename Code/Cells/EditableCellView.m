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

#import "EditableCellView.h"

#import "SSTextField.h"


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EditableCellView


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField = [[SSTextField alloc] init];
        self.textField.textAlignment = kCTLeftTextAlignment;
        self.textField.font = [UIFont boldSystemFontOfSize:18];
        CGFloat verticalSpacing = 15;
        [self.textField setTextEdgeInsets:UIEdgeInsetsMake(verticalSpacing, 10, verticalSpacing, 10)];
        
        [self.contentView addSubview:self.textField];
        
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-cell.png"]];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = self.contentView.frame.size.width - self.detailTextLabel.frame.size.width - 10;
    frame.size.height = self.contentView.frame.size.height;

    self.textField.frame = frame;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    [self.textField setEnabled:editing];
    
    [UIView animateWithDuration:0.33 animations:^{
        self.detailTextLabel.alpha = (editing) ? 0 : 1;
    }];
    
    NSString *accessoryViewImage = (editing ? @"cell-sort.png" : @"cell-accessory.png");
    
    UIImageView *cellAccessory = [[UIImageView alloc] initWithImage:[UIImage imageNamed:accessoryViewImage]];
    self.accessoryView = cellAccessory;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (UITableViewCellStyle)cellStyle {
    return UITableViewCellStyleValue1;
}


@end
