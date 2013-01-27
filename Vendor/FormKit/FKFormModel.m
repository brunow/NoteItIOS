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

#import "FKFormModel.h"

#import "FKFormMapping.h"
#import "FKFormMapper.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"
#import "FKSaveButtonField.h"
#import "FKFields.h"
#import "NSObject+FKFormAttributeMapping.h"
#import "BWSelectViewController.h"
#import "UIView+FormKit.h"
#import "BWLongTextViewController.h"


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface FKFormModel ()

@property (nonatomic, retain) FKFormMapping *formMapping;
@property (nonatomic, retain) FKFormMapper *formMapper;

- (void)showTextViewControllerWithAttributeMapping:(FKFormAttributeMapping *)attributeMapping;

- (void)showSelectPickerWithAttributeMapping:(FKFormAttributeMapping *)attributeMapping;

- (void)showDatePickerWithAttributeMapping:(FKFormAttributeMapping *)attributeMapping;

- (void)showSelectWithAttributeMapping:(FKFormAttributeMapping *)attributeMapping;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FKFormModel

@synthesize tableView = _tableView;
@synthesize formMapping = _formMapping;
@synthesize object = _object;
@synthesize formMapper = _formMapper;
@synthesize navigationController = _navigationController;
@synthesize selectControllerClass = _selectControllerClass;
@synthesize longTextControllerClass = _longTextControllerClass;
@synthesize didChangeValueBlock = _didChangeValueBlock;
@synthesize configureCellsBlock = _configureCellsBlock;


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)formTableModelForTableView:(UITableView *)tableView {
    return [self formTableModelForTableView:tableView navigationController:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)formTableModelForTableView:(UITableView *)tableView
            navigationController:(UINavigationController *)navigationController {
    
    return [[self alloc] initWithTableView:tableView
                      navigationController:navigationController];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithTableView:(UITableView *)tableView
   navigationController:(UINavigationController *)navigationController {
    
    self = [self init];
    if (self) {
        self.tableView = tableView;
        self.navigationController = navigationController;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        self.selectControllerClass = [BWSelectViewController class];
        self.longTextControllerClass = [BWLongTextViewController class];
        self.validationErrorColor = [UIColor colorWithRed:216/255.0f green:98/255.0f blue:98/255.0f alpha:1];
        self.validationErrorCellBackgroundColor = [UIColor colorWithRed:255/255.0f green:235/255.0f blue:235/255.0f alpha:1];
        self.validationNormalCellBackgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:1];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSections {
    return [self.formMapper numberOfSections];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return [self.formMapper numberOfRowsInSection:section];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)titleForHeaderInSection:(NSInteger)section {
    return [self.formMapper titleForHeaderInSection:section];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)titleForFooterInSection:(NSInteger)section {
    return [self.formMapper titleForFooterInSection:section];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.formMapper cellForRowAtIndexPath:indexPath];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self.tableView.superview fk_findFirstResponder] resignFirstResponder];
    
    FKFormAttributeMapping *attributeMapping = [self.formMapper attributeMappingAtIndexPath:indexPath];
    
    if (nil != attributeMapping.selectValuesBlock) {
        if (attributeMapping.showInPicker)
            [self showSelectPickerWithAttributeMapping:attributeMapping];
        else
            [self showSelectWithAttributeMapping:attributeMapping];
        
    } else if (nil != attributeMapping.saveBtnHandler) {
        attributeMapping.saveBtnHandler();
        
    } else if (nil != attributeMapping.btnHandler) {
        attributeMapping.btnHandler(self.object);
        
    } else if (FKFormAttributeMappingTypeBigText == attributeMapping.type) {
        [self showTextViewControllerWithAttributeMapping:attributeMapping];

    } else if (FKFormAttributeMappingTypeText == attributeMapping.type) {
        FKTextField *textFieldCell = (FKTextField *)[self cellForRowAtIndexPath:indexPath];
        [textFieldCell.textField becomeFirstResponder];
        
    } else if (FKFormAttributeMappingTypeDateTime == attributeMapping.type ||
               FKFormAttributeMappingTypeTime == attributeMapping.type ||
               FKFormAttributeMappingTypeDate == attributeMapping.type) {
        
        [self showDatePickerWithAttributeMapping:attributeMapping];
        
    } else if (FKFormAttributeMappingTypeCustomCell == attributeMapping.type) {
        if (nil != attributeMapping.cellSelectionBlock) {
            UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
            attributeMapping.cellSelectionBlock(cell, self.object, indexPath);
        }
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)registerMapping:(FKFormMapping *)formMapping {
    self.formMapping = formMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadFieldsWithObject:(id)object {
    self.object = object;
    
    self.formMapper = [[FKFormMapper alloc] initWithFormMapping:self.formMapping
                                                      tabelView:self.tableView
                                                         object:self.object
                                                      formModel:self];
    
    [self.tableView reloadData];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reloadRowWithIdentifier:(NSString *)identifier {
    __block BOOL hasReloadedRow = NO;
    
    [self.formMapping.attributeMappings enumerateKeysAndObjectsUsingBlock:^(id key, FKFormAttributeMapping *attributeMapping, BOOL *stop) {
        if ([attributeMapping.attribute isEqualToString:identifier]) {
            [self reloadRowWithAttributeMapping:attributeMapping];
            *stop = YES;
            hasReloadedRow = YES;
        }
    }];
    
    NSAssert(YES == hasReloadedRow, @"Identifier doesn't exist, so cannot reload row");
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reloadRowWithAttributeMapping:(FKFormAttributeMapping *)attributeMapping {
    NSIndexPath *indexPath = [self.formMapper indexPathOfAttributeMapping:attributeMapping];;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reloadSectionWithIdentifier:(NSString *)sectionIdentifier {
    NSUInteger sectionIndex = [self.formMapper.titles indexOfObject:sectionIdentifier];
    
    NSAssert(sectionIndex != NSNotFound, @"Section doesn't exist");
    
    if (NSNotFound != sectionIndex) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                      withRowAnimation:UITableViewRowAnimationNone];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setDidChangeValueWithBlock:(FKFormMappingDidChangeValueBlock)didChangeValueBlock {
    _didChangeValueBlock = didChangeValueBlock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)configureCells:(FKFormMappingConfigureCellBlock)configureCellsBlock {
    _configureCellsBlock = configureCellsBlock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)findFirstTextField {
    return [self.tableView fk_findFirstTextField];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)findTextFields {
    return [self.tableView fk_findTextFields];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)save {
    // Because value of UITextField is saved after resign
    [[self.tableView fk_findFirstResponder] resignFirstResponder];
    
    [self validateForm];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)validateForm {
    [self.formMapping.attributeValidations enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.formMapper validateFieldWithAttribute:key];
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Getters and setters


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTableView:(UITableView *)tableView {
    if (_tableView != tableView) {
        _tableView = tableView;
    }
    
    tableView.dataSource = self;
    tableView.delegate = self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (object != _object) {
        _object = object;
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDataSource


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRowsInSection:section];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellForRowAtIndexPath:indexPath];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self titleForHeaderInSection:section];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self titleForFooterInSection:section];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.formMapper heightForRowAtIndexPath:indexPath];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDelegate


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self didSelectRowAtIndexPath:indexPath];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIScrollViewDelegate


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[[[UIApplication sharedApplication] keyWindow] fk_findFirstResponder] resignFirstResponder];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showTextViewControllerWithAttributeMapping:(FKFormAttributeMapping *)attributeMapping {
    Class controllerClass = (attributeMapping.controllerClass == nil) ?
                            self.longTextControllerClass : attributeMapping.controllerClass;
    
    NSString *value = [self.formMapper valueForAttributeMapping:attributeMapping];
    BWLongTextViewController *vc = [[controllerClass alloc] initWithText:value];
    vc.title = attributeMapping.title;
    vc.textView.delegate = self.formMapper;
    vc.textView.formAttributeMapping = attributeMapping;
    [self.navigationController pushViewController:vc animated:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showSelectPickerWithAttributeMapping:(FKFormAttributeMapping *)attributeMapping {
    __weak FKFormModel *weakRef = self;
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        FKFormAttributeMapping *formAttributeMapping = picker.formAttributeMapping;
        id value = formAttributeMapping.valueFromSelectBlock(selectedValue, self.object, selectedIndex);
        [weakRef.formMapper setValue:value forAttributeMapping:formAttributeMapping];
        [weakRef reloadRowWithAttributeMapping:formAttributeMapping];
    };
    
    NSString *value = [self.formMapper valueForAttributeMapping:attributeMapping];
    NSInteger selectedIndex = 0;
    ActionSheetStringPicker *picker;
    picker = [ActionSheetStringPicker showPickerWithTitle:attributeMapping.title
                                                     rows:attributeMapping.selectValuesBlock(value, self.object, &selectedIndex)
                                         initialSelection:selectedIndex
                                                doneBlock:done
                                              cancelBlock:nil
                                                   origin:(nil == self.viewOrigin) ? self.tableView : self.viewOrigin];
    
    picker.formAttributeMapping = attributeMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showSelectWithAttributeMapping:(FKFormAttributeMapping *)attributeMapping {
    NSInteger selectedIndex = 0;
    BWSelectViewController *vc = [[self.selectControllerClass alloc] init];
    vc.items = attributeMapping.selectValuesBlock(nil, self.object, &selectedIndex);
    vc.title = attributeMapping.title;
    vc.formAttributeMapping = attributeMapping;
    [vc setSlectedIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:selectedIndex inSection:0]]];
    
    
    __weak FKFormModel *weakRef = self;
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSIndexPath *selectedIndexPath = [selectedIndexPaths lastObject];
        NSUInteger selectedIndex = selectedIndexPath.row;
        id selectedValue = [controller.items objectAtIndex:selectedIndex];
        FKFormAttributeMapping *formAttributeMapping = controller.formAttributeMapping;
        id value = formAttributeMapping.valueFromSelectBlock(selectedValue, self.object, selectedIndex);
        [weakRef.formMapper setValue:value forAttributeMapping:formAttributeMapping];
        [weakRef reloadRowWithAttributeMapping:formAttributeMapping];
        [controller.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showDatePickerWithAttributeMapping:(FKFormAttributeMapping *)attributeMapping {
    ActionSheetDatePicker *actionSheetPicker;
    UIDatePickerMode datePickerMode = UIDatePickerModeDate;
    
    if (FKFormAttributeMappingTypeTime == attributeMapping.type) {
        datePickerMode = UIDatePickerModeTime;
    } else if (FKFormAttributeMappingTypeDateTime == attributeMapping.type) {
        datePickerMode = UIDatePickerModeDateAndTime;
    }
    
    __weak FKFormModel *weakRef = self;
    actionSheetPicker = [ActionSheetDatePicker showPickerWithTitle:attributeMapping.title
                                                    datePickerMode:datePickerMode
                                                      selectedDate:[NSDate date]
                                                         doneBlock:^(ActionSheetDatePicker *picker, NSDate *selectedDate, id origin) {
                                                             FKFormAttributeMapping *formAttributeMapping = picker.formAttributeMapping;
                                                             [weakRef.formMapper setValue:selectedDate forAttributeMapping:formAttributeMapping];
                                                             [weakRef reloadRowWithAttributeMapping:formAttributeMapping];
                                                         }
                                                       cancelBlock:nil
                                                            origin:self.tableView];
    
    actionSheetPicker.formAttributeMapping = attributeMapping;
}



@end
