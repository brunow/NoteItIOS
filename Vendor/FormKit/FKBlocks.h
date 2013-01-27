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

@class FKFormAttributeMapping;

typedef void(^FKBasicBlock)();

typedef NSArray *(^FKFormMappingSelectValueBlock)(id value, id object, NSInteger *selectedValueIndex);

typedef id(^FKFormMappingValueFromSelectBlock)(id value, id object, NSInteger selectedValueIndex);

typedef void(^FKFormMappingButtonHandlerBlock)(id object);

typedef NSString *(^FKFormMappingDateFormatBlock)();

typedef id (^FKFormMappingSelectLabelValueBlock)(id value, id object);

typedef void(^FKFormMappingWillDisplayCellBlock)(UITableViewCell *cell, id object, NSIndexPath *indexPath);

typedef void(^FKFormMappingCellSelectionBlock)(UITableViewCell *cell, id object, NSIndexPath *indexPath);

typedef NSString *(^FKFormMappingSliderValueBlock)(id value);

typedef void(^FKFormMappingDidChangeValueBlock)(id object, id value, NSString *keyPath);

typedef void(^FKFormMappingConfigureCellBlock)(UITableViewCell *cell);

typedef void(^FKFormMappingAttributeMappingBlock)(FKFormAttributeMapping *mapping);

typedef BOOL(^FKFormMappingIsValueValidBlock)(id value, id object);

typedef NSString *(^FKFormMappingFieldErrorStringBlock)(id value, id object);