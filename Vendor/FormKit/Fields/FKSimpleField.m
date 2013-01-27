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

#import "FKSimpleField.h"

#import "UITableViewCell+FormKit.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FKSimpleField


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.errorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.errorLabel.backgroundColor = [UIColor clearColor];
        self.errorLabel.numberOfLines = 0;
        self.errorLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:self.errorLabel];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.errorLabel.text = nil;
    self.backgroundColor = [UIColor whiteColor];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.y = 10;
    self.textLabel.frame = textLabelFrame;
    
    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
    detailTextLabelFrame.origin.y = 10;
    self.detailTextLabel.frame = detailTextLabelFrame;
    
    if (nil != self.errorLabel.text) {
        CGFloat errorLabelWidth = self.contentView.frame.size.width - self.textLabel.frame.origin.x * 2;
        
        CGSize stringSize = [self.errorLabel.text sizeWithFont:self.errorLabel.font
                                             constrainedToSize:CGSizeMake(errorLabelWidth, 5000)
                                                 lineBreakMode:self.errorLabel.lineBreakMode];
        
        self.errorLabel.frame = CGRectMake(self.textLabel.frame.origin.x,
                                           self.textLabel.frame.origin.y + self.textLabel.frame.size.height + 10,
                                           errorLabelWidth,
                                           stringSize.height);
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark FKFieldErrorProtocol


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addError:(NSString *)error {
    self.errorLabel.text = error;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)errorHeightWithError:(NSString *)error tableView:(UITableView *)tableView {
    static CGFloat contentViewWidth = 0;
    static UIFont *errorLabelFont = nil;
    static UILineBreakMode errorLabelLineBreakMode = 0;
    
    if (0 == contentViewWidth) {
        FKSimpleField<FKFieldErrorProtocol> *cell = [self fk_cellForTableView:tableView configureCell:nil];
        contentViewWidth = cell.contentView.frame.size.width - cell.textLabel.frame.origin.x * 2;
        
        errorLabelFont = cell.errorLabel.font;
        errorLabelLineBreakMode = cell.errorLabel.lineBreakMode;
    }
    
    CGSize stringSize = [error sizeWithFont:errorLabelFont
                          constrainedToSize:CGSizeMake(contentViewWidth, 5000)
                              lineBreakMode:errorLabelLineBreakMode];
    
    return stringSize.height + 5;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setErrorTextColor:(UIColor *)color {
    self.errorLabel.textColor = color;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setErrorBackgroundColor:(UIColor *)color {
    self.backgroundColor = color;
}


@end
