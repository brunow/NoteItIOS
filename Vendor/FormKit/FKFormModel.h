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

#import <Foundation/Foundation.h>

#import "FKBlocks.h"

@class BKCellMapping;
@class FKFormMapping;
@class FKFormAttributeMapping;

@interface FKFormModel : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) id object;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, assign) Class selectControllerClass;
@property (nonatomic, assign) Class longTextControllerClass;
@property (nonatomic, copy, readonly) FKFormMappingDidChangeValueBlock didChangeValueBlock;
@property (nonatomic, copy, readonly) FKFormMappingConfigureCellBlock configureCellsBlock;
@property (nonatomic, retain) UIView *viewOrigin;

/**
 A set of attribute names with invalid values.
 
 Make sure you use the same strings that you used when mapping  attributes.
 
 You should call reloadData on your table view after setting this value.
 */
@property (nonatomic,strong) NSSet *invalidAttributes;

/**
 Default text color used for the title label in table cells for attribues with valid values.
 
 The default is black.
 
 Not used anymore
 */
@property (nonatomic,strong) UIColor *validationNormalColor DEPRECATED_ATTRIBUTE;

/**
 Color used for the title label in table cells for attribues with invalid values.
 
 The default is red.
 */
@property (nonatomic,strong) UIColor *validationErrorColor;

/**
 Cell background color in table cells for attribues with values.
 */
@property (nonatomic, strong) UIColor *validationNormalCellBackgroundColor;

/**
 Cell background color in table cells for attribues with invalid values.
 */
@property (nonatomic, strong) UIColor *validationErrorCellBackgroundColor;

+ (id)formTableModelForTableView:(UITableView *)tableView;

+ (id)formTableModelForTableView:(UITableView *)tableView
            navigationController:(UINavigationController *)navigationController;

- (id)initWithTableView:(UITableView *)tableView
   navigationController:(UINavigationController *)navigationController;

- (void)registerMapping:(FKFormMapping *)formMapping;

- (void)loadFieldsWithObject:(id)object;

- (void)reloadRowWithIdentifier:(NSString *)identifier;

- (void)reloadRowWithAttributeMapping:(FKFormAttributeMapping *)attributeMapping;

- (void)reloadSectionWithIdentifier:(NSString *)sectionIdentifier;

- (void)setDidChangeValueWithBlock:(FKFormMappingDidChangeValueBlock)didChangeValueBlock;

- (void)configureCells:(FKFormMappingConfigureCellBlock)configureCellsBlock;

/**
 Find the first UITextField or UITextView in the table view.
 @return Return first UITextField or UITextView.
 */
- (id)findFirstTextField;

/**
 Find all UITextField or UITextView in the table view.
 @return Return an array of UITextField and UITextView.
 */
- (NSArray *)findTextFields;

/**
 Save all attributes
 */
- (void)save;

- (void)validateForm;

@end
