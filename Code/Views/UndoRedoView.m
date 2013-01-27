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

#import "UndoRedoView.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UndoRedoView


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *btnImage = [[UIImage imageNamed:@"toolbar-btn-dark.png"]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(7, 13, 7, 13)];
        
        UIEdgeInsets titleEdge = UIEdgeInsetsMake(0, 7, 0, 7);
        
        self.undoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.undoBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        [self.undoBtn setTitle:@"Undo" forState:UIControlStateNormal];
        self.undoBtn.contentEdgeInsets = titleEdge;
        
        self.redoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.redoBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
        [self.redoBtn setTitle:@"Redo" forState:UIControlStateNormal];
        self.redoBtn.contentEdgeInsets = titleEdge;
        
        UIFont *font = [UIFont boldSystemFontOfSize:13];
        
        self.undoBtn.titleLabel.font = font;
        self.redoBtn.titleLabel.font = font;
        
        [self addSubview:self.undoBtn];
        [self addSubview:self.redoBtn];
        
        [self setNeedsLayout];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.undoBtn sizeToFit];
    [self.redoBtn sizeToFit];
    
    CGFloat leftShift = (BKIsPad() ? 15 : 0);
    
    CGFloat top = (self.frame.size.height - self.redoBtn.frame.size.height) / 2;
    
    self.undoBtn.frame = CGRectMake(leftShift, top, self.undoBtn.frame.size.width, self.undoBtn.frame.size.height);
    
    self.redoBtn.frame = CGRectMake(self.frame.size.width - self.redoBtn.frame.size.width + leftShift,
                                    top,
                                    self.redoBtn.frame.size.width,
                                    self.redoBtn.frame.size.height);
}


@end
