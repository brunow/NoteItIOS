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

#import "FKFormAttributeMapping.h"


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FKFormAttributeMapping

@synthesize mappingType = _mappingType;
@synthesize attribute = _attribute;
@synthesize title = _title;
@synthesize type = _type;
@synthesize selectValuesBlock = _selectValuesBlock;
@synthesize valueFromSelectBlock = _valueFromSelectBlock;
@synthesize placeholderText = _placeholderText;
@synthesize saveBtnHandler = _saveBtnHandler;
@synthesize btnHandler = _btnHandler;
@synthesize accesoryType = _accesoryType;
@synthesize dateFormat = _dateFormat;
@synthesize dateFormatBlock = _dateFormatBlock;
@synthesize labelValueBlock = _labelValueBlock;
@synthesize willDisplayCellBlock = _willDisplayCellBlock;
@synthesize cellSelectionBlock = _cellSelectionBlock;
@synthesize customCell = _customCell;
@synthesize rowHeight = _rowHeight;
@synthesize controllerClass = _controllerClass;
@synthesize minValue = _minValue;
@synthesize maxValue = _maxValue;
@synthesize showInPicker = _showInPicker;
@synthesize sliderValueBlock = _sliderValueBlock;
@synthesize keyboardType = _keyboardType;


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        self.keyboardType = UIKeyboardTypeNumberPad;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)attributeMapping {
    return [[self alloc] init];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setType:(FKFormAttributeMappingType)type {
    _type = type;
    
    if (FKFormAttributeMappingTypeFloat == type) {
        self.keyboardType = UIKeyboardTypeDecimalPad;
    } else if (FKFormAttributeMappingTypeInteger == type) {
        self.keyboardType = UIKeyboardTypeNumberPad;
        
    } else {
        self.keyboardType = UIKeyboardTypeDefault;
    }
}


@end
