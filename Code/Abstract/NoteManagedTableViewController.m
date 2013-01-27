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

#import "NoteManagedTableViewController.h"

#import "UITableView+IndexPathFromView.h"

#import "UITableView+NXEmptyView.h"
#import "ExecuteEveryTime.h"
#import "SSLabel.h"
#import "CreateInPlaceView.h"
#import "User.h"

#define OVERLAY_VIEW_TAG 510000

#define EMPTY_LABEL_INNER_SPACING 10

@interface NoteManagedTableViewController ()

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NoteManagedTableViewController


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 50;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10)];
    footerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableview-footer.png"]];
    self.tableView.tableFooterView = footerView;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tableview-patern.png"]];
    
    self.tableView.nxEV_emptyView = [self viewForEmptyTableView];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self unloadInPlaceCreation];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __weak NoteManagedTableViewController *weakRef = self;
    [ExecuteEveryTime executeBlock:^{
        [weakRef fetchResource];
        
    } everyTime:60 name:NSStringFromClass([self class])];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchResource)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [ExecuteEveryTime stopExecuteBlockWithName:NSStringFromClass([self class])];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)resignFirstResponder {
    [[[[UIApplication sharedApplication] keyWindow] findFirstResponder] resignFirstResponder];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSUInteger)supportedInterfaceOrientations {
    return BKIsPad() ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardFrameDidChange {
    [super keyboardFrameDidChange];
    
    if (nil != self.scrollToIndexPath && [self.tableView isEditing] && NO == self.isKeyboardHidden) {
        [self.tableView scrollToRowAtIndexPath:self.scrollToIndexPath
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
        
        self.scrollToIndexPath = nil;
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)titleIfNoItemInTableView {
    return nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Resource


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)canFetchResource {
    return [User isLoggedIn];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)reloadResourceIfReachable {
    return YES;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TableModel


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)createTableModel {
    return YES;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITextFieldDelegate


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.tableView isEditing]) {
        self.scrollToIndexPath = [self.tableView indexPathForRowContainingView:textField];
        
    } else if (textField == self.creationInPlaceView.textField) {
        UIView *overlay = [self overlay];
        [self.tableView addSubview:overlay];
        [self.tableView bringSubviewToFront:self.creationInPlaceView.textField];
        self.tableView.scrollEnabled = NO;
        
        self.tableView.editing = NO;
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.creationInPlaceView.textField) {
        [textField resignFirstResponder];
    }
    
    return YES;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.creationInPlaceView.textField) {
        UIView *overlay = [self.view viewWithTag:OVERLAY_VIEW_TAG];
        UITapGestureRecognizer *tapGesture = [overlay.gestureRecognizers lastObject];
        [overlay removeGestureRecognizer:tapGesture];
        [overlay removeFromSuperview];
        self.tableView.scrollEnabled = YES;
        [self createItem];
        
    } else {
        NSIndexPath *indexPath = [self.tableView indexPathForRowContainingView:textField];
        
        if (nil != indexPath) {
            id object = [self.tableModel objectForRowAtIndexPath:indexPath];
            self.editBlock(object, textField.text);
        }
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPressToggleEdit:(id)sender {
    [self.tableView toggleEditAnimated:YES];
    self.navigationItem.rightBarButtonItem = [self editButton];
    
    self.toggleEditBlock([self.tableView isEditing]);
    [self hideInPlaceCreateTextFieldAnimated:YES];
    
    UIView *firstResponder = [[[UIApplication sharedApplication] keyWindow] findFirstResponder];
    [firstResponder resignFirstResponder];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPressCreate {
    [self createItem];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Helpers


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)overlay {
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectZero];
    overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    overlay.backgroundColor = BK_RGBA_COLOR(0, 0, 0, 0.5);
    overlay.tag = OVERLAY_VIEW_TAG;
    
    CGFloat lineHeight = self.creationInPlaceView.lineView.frame.size.height;
    
    overlay.frame = CGRectMake(0,
                               CGRectGetHeight(self.creationInPlaceView.frame) - lineHeight,
                               CGRectGetWidth(self.creationInPlaceView.frame),
                               CGRectGetHeight(self.currentViewBounds) - CGRectGetHeight(self.creationInPlaceView.frame) + lineHeight);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(stopAdding)];
    
    [overlay addGestureRecognizer:tapGesture];
    
    return overlay;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIBarButtonItem *)editButton {
    UIBarButtonItem *editBtnItem = [UIBarButtonItem barButtonSystemItem:(self.tableView.editing ? UIBarButtonSystemItemDone : UIBarButtonSystemItemEdit)
                                                                 target:self
                                                                 action:@selector(didPressToggleEdit:)];
    
    return editBtnItem;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView *)viewForEmptyTableView {
    NSString *titleString = [NSString stringWithFormat:@"%@ :(\n", [self titleIfNoItemInTableView]];
    NSString *subTitleString = @"Drag to bottom to add new item.";
    
    NSRange titleRange = NSMakeRange(0, [titleString length]);
    NSRange subTitleRange = NSMakeRange([titleString length], [subTitleString length]);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", titleString, subTitleString]];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont boldSystemFontOfSize:34]
                             range:titleRange];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont boldSystemFontOfSize:14]
                             range:subTitleRange];
    
    SSLabel *titleLabel = [[SSLabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 30);
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    titleLabel.shadowColor = [UIColor blackColor];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 2;
    titleLabel.attributedText = attributedString;
    titleLabel.textEdgeInsets = UIEdgeInsetsMake(0, EMPTY_LABEL_INNER_SPACING, 0, EMPTY_LABEL_INNER_SPACING);
    
    return titleLabel;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setuptEditInPlaceWithEditBlock:(EditInPlaceBlock)block
                       toggleEditBlock:(EditInPlaceToggleEditBlock)toggleEditBlock {
    
    self.navigationItem.rightBarButtonItem = [self editButton];
    self.editBlock = block;
    self.toggleEditBlock = toggleEditBlock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setuptInPlaceCreationWithCreationBlock:(InPlaceCreateBlock)block placeholder:(NSString *)placeholder {
    self.observingScrollView = NO;
    
    self.creationInPlaceView = [[CreateInPlaceView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 45)];
    self.creationInPlaceView.textField.delegate = self;
    self.creationInPlaceView.textField.returnKeyType = UIReturnKeyDone;
    
    [self.creationInPlaceView.addBtn addTarget:self
                                        action:@selector(didPressCreate)
                              forControlEvents:UIControlEventTouchUpInside];
    UITextField *textField = self.creationInPlaceView.textField;
    textField.placeholder = placeholder;
    self.tableView.tableHeaderView = self.creationInPlaceView;
    self.creationBlock = block;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)unloadInPlaceCreation {
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)hideInPlaceCreateTextFieldAnimated:(BOOL)animated {
    [[[UIApplication sharedApplication].keyWindow findFirstResponder] resignFirstResponder];
    CGFloat lineHeight = self.creationInPlaceView.lineView.frame.size.height + 1;
    UIEdgeInsets contentInset = UIEdgeInsetsMake(-(self.creationInPlaceView.frame.size.height + lineHeight - 1), 0, 0, 0);
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableView setContentInset:contentInset];
        }];
    } else {
        [self.tableView setContentInset:contentInset];
    }
    
    [self startObservingScrollView];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showInPlaceCreateTextFieldAnimated:(BOOL)animated {
    UIEdgeInsets contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableView setContentInset:contentInset];
        }];
    } else {
        [self.tableView setContentInset:contentInset];
    }
    
    [self startObservingScrollView];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createItem {
    UITextField *textField = self.creationInPlaceView.textField;
    
    if (0 == textField.text.length)
        return;
    
    self.creationBlock(textField.text);
    [self stopAdding];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)stopAdding {
    UITextField *textField = self.creationInPlaceView.textField;
    [textField resignFirstResponder];
    textField.text = nil;
    [self hideInPlaceCreateTextFieldAnimated:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)startObservingScrollView {
    if (NO == [self isObservingScrollView]) {
        [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        self.observingScrollView = YES;
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)inPlaceCreateScrollViewDidScroll:(CGPoint)contentOffset {
    if (NO == [self.tableView isEditing] && contentOffset.y <= 3) {
        [self showInPlaceCreateTextFieldAnimated:YES];
        [self.creationInPlaceView.textField becomeFirstResponder];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if([keyPath isEqualToString:@"contentOffset"])
        [self inPlaceCreateScrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
}


@end
