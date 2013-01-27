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

#import "ToolbarInputAccessoryView.h"

#import "Settings.h"

#define LINE_VIEW_HEIGHT 1

#define SCREEN_BOUNDS [[UIScreen mainScreen] bounds]

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ToolbarInputAccessoryView ()

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ToolbarInputAccessoryView


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        self.listType = ToolbarInputAccessoryViewListTypeEditing;
        
        BOOL preferMarkdownSyntax = [Settings isPreferingMarkdownSyntax];
        
        self.boldBtn = [self toolbarButtonWithTitle:preferMarkdownSyntax ? @"**" : @"B"
                                             action:@selector(didPressBoldize:)];
        
        self.italicBtn = [self toolbarButtonWithTitle:preferMarkdownSyntax ? @"_" : @"I"
                                               action:@selector(didPressItalize:)];
        
        self.orderedListBtn = [self toolbarButtonWithTitle:@"1."
                                                    action:@selector(didPressOrderedList:)];
        
        self.unOrderedListBtn = [self toolbarButtonWithTitle:@"-"
                                                      action:@selector(didPressUnorderedList:)];
        
        self.deleteBtn = [self toolbarButtonWithTitle:@"X"
                                               action:@selector(didPressDelete:)];
        
        self.titleBtn = [self toolbarButtonWithTitle:preferMarkdownSyntax ? @"#" : @"Title"
                                              action:@selector(didPressTitleize:)];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
        self.lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hr-line.png"]];
        self.lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.toolbar = [[UIToolbar alloc] init];
        self.toolbar.items = [self editItems];
        [self.toolbar sizeToFit];
        self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.toolbar.frame = CGRectMake(0,
                                        LINE_VIEW_HEIGHT,
                                        CGRectGetWidth(self.toolbar.frame),
                                        CGRectGetHeight(self.toolbar.frame));
        
        self.frame = CGRectMake(0, 0,
                                CGRectGetWidth(self.toolbar.frame),
                                CGRectGetHeight(self.toolbar.frame) + CGRectGetHeight(self.lineView.frame));
        
        self.lineView.frame = CGRectMake(0, 0, self.frame.size.width, LINE_VIEW_HEIGHT);
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:self.lineView];
        [self addSubview:self.toolbar];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPressDelete:(id)sender {
    [self.delegate toolbarInputAccessoryView:self didSelectDelete:sender];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPressTitleize:(id)sender {
    [self.delegate toolbarInputAccessoryView:self didSelectTitleize:sender];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPressBoldize:(id)sender {
    [self.delegate toolbarInputAccessoryView:self didSelectBoldize:sender];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPressItalize:(id)sender {
    [self.delegate toolbarInputAccessoryView:self didSelectItalize:sender];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPressOrderedList:(id)sender {
    [self.delegate toolbarInputAccessoryView:self didSelectList:sender ordered:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPressUnorderedList:(id)sender {
    [self.delegate toolbarInputAccessoryView:self didSelectList:sender ordered:NO];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPressMoveCursor:(id)sender {
    self.listType = (ToolbarInputAccessoryViewListTypeEditing == self.listType) ?
    ToolbarInputAccessoryViewListTypeMove : ToolbarInputAccessoryViewListTypeEditing;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPressMoveCursorLeft:(id)sender {
    [self.delegate toolbarInputAccessoryView:self
                         didSelectMoveCursor:sender
                               moveDirection:ToolbarInputAccessoryViewCursorMoveDirectionLeft];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPressMoveCursorRight:(id)sender {
    [self.delegate toolbarInputAccessoryView:self
                         didSelectMoveCursor:sender
                               moveDirection:ToolbarInputAccessoryViewCursorMoveDirectionRight];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIBarButtonItem *)itemSeparator {
    UIBarButtonItem *space = [UIBarButtonItem barButtonSystemItem:(BKIsPad() ? UIBarButtonSystemItemFixedSpace : UIBarButtonSystemItemFlexibleSpace)
                                                           target:nil
                                                           action:nil];
    
    if (BKIsPad()) {
        space.width = 40;
    }
    
    return space;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)editItems {
    UIBarButtonItem *flexible = [UIBarButtonItem barButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                              target:nil
                                                              action:nil];
    
    UIBarButtonItem *itemSeparator = [self itemSeparator];
    
    UIBarButtonItem *titleize = [[UIBarButtonItem alloc] initWithCustomView:self.titleBtn];
    
    UIBarButtonItem *boldize = [[UIBarButtonItem alloc] initWithCustomView:self.boldBtn];
    
    UIBarButtonItem *italize = [[UIBarButtonItem alloc] initWithCustomView:self.italicBtn];
    
    UIBarButtonItem *ordered = [[UIBarButtonItem alloc] initWithCustomView:self.orderedListBtn];
    
    UIBarButtonItem *unordered = [[UIBarButtonItem alloc] initWithCustomView:self.unOrderedListBtn];
    
    UIBarButtonItem *deleteLine = [[UIBarButtonItem alloc] initWithCustomView:self.deleteBtn];
    
    return @[
    titleize, itemSeparator,
    italize, itemSeparator,
    boldize, itemSeparator,
    ordered, itemSeparator,
    unordered, flexible,
    deleteLine
    ];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIButton *)toolbarButtonWithTitle:(NSString *)title action:(SEL)action {
    UIImage *toolBarBtn = [[UIImage imageNamed:@"toolbar-btn-light.png"]
                           resizableImageWithCapInsets:UIEdgeInsetsMake(15, 6, 15, 6)];
    
    UIImage *toolBarSelectedBtn = [[UIImage imageNamed:@"toolbar-btn-dark.png"]
                                   resizableImageWithCapInsets:UIEdgeInsetsMake(15, 6, 15, 6)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:toolBarBtn forState:UIControlStateNormal];
    [btn setBackgroundImage:toolBarSelectedBtn forState:UIControlStateSelected];
    
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 11, 0, 11);
    
    [btn sizeToFit];
    
    CGRect frame = btn.frame;
    CGFloat minWidth = BKIsPad() ? 55 : 35;
    frame.size.width = MAX(minWidth, frame.size.width);
    btn.frame = frame;
    
    [btn addTarget:self
            action:action
  forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}


@end
