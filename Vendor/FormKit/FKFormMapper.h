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

@class FKFormMapping;
@class FKFormAttributeMapping;
@class FKFormModel;

@interface FKFormMapper : NSObject <UITextFieldDelegate, UITextViewDelegate> {
    FKFormMapping *_formMapping;
    UITableView *_tableView;
    id _object;
    __weak FKFormModel *_formModel;
}

@property (nonatomic, readonly) FKFormMapping *formMapping;
@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) id object;
@property (nonatomic, readonly) FKFormModel *formModel;
@property (nonatomic, readonly) NSArray *titles;

- (id)initWithFormMapping:(FKFormMapping *)formMapping
                tabelView:(UITableView *)tableView
                   object:(id)object
                formModel:(FKFormModel *)formModel;

- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (NSString *)titleForHeaderInSection:(NSInteger)section;

- (NSString *)titleForFooterInSection:(NSInteger)sectionIndex;

- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (FKFormAttributeMapping *)attributeMappingAtIndexPath:(NSIndexPath *)indexPath;

- (id)valueForAttributeMapping:(FKFormAttributeMapping *)attributeMapping;

- (void)setValue:(id)value forAttributeMapping:(FKFormAttributeMapping *)attributeMapping;

- (NSIndexPath *)indexPathOfAttributeMapping:(FKFormAttributeMapping *)attributeMapping;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)validateFieldWithAttribute:(NSString *)attribute;

@end
