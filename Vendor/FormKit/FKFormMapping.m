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

#import "FKFormMapping.h"

#import "FKFormAttributeMapping.h"
#import "FKFields.h"
#import "FKSectionObject.h"
#import "FKFormAttributeValidation.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface FKFormMapping ()

- (void)addFieldToOrdersArray:(NSString *)identifier;

- (void)addAttributeMappingToFormMapping:(FKFormAttributeMapping *)attributeMapping;

- (FKFormAttributeMapping *)attributeMappingWithTitle:(NSString *)title
                                            attribute:(NSString *)attribute
                                                 type:(FKFormAttributeMappingType)type;


@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FKFormMapping

@synthesize objectClass = _objectClass;
@synthesize fieldsOrder = _fieldsOrder;
@synthesize saveAttribute = _saveAttribute;
@synthesize textFieldClass = _textFieldClass;
@synthesize floatFieldClass = _floatFieldClass;
@synthesize integerFieldClass = _integerFieldClass;
@synthesize labelFieldClass = _labelFieldClass;
@synthesize passwordFieldClass = _passwordFieldClass;
@synthesize switchFieldClass = _switchFieldClass;
@synthesize saveButtonFieldClass = _saveButtonFieldClass;
@synthesize disclosureIndicatorAccessoryField = _disclosureIndicatorAccessoryField;
@synthesize sliderFieldClass = _sliderFieldClass;
@synthesize buttonFieldClass = _buttonFieldClass;
@synthesize attributeMappings = _attributeMappings;


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        _attributeMappings = [[NSMutableDictionary alloc] init];
        _sectionTitles = [[NSMutableDictionary alloc] init];
        _fieldsOrder = [[NSMutableArray alloc] init];
        _attributeValidations = [[NSMutableDictionary alloc] init];
        _textFieldClass = [FKTextField class];
        _floatFieldClass = [FKFloatField class];
        _integerFieldClass = [FKIntegerField class];
        _labelFieldClass = [FKLabelField class];
        _passwordFieldClass = [FKPasswordTextField class];
        _switchFieldClass = [FKSwitchField class];
        _saveButtonFieldClass = [FKSaveButtonField class];
        _disclosureIndicatorAccessoryField = [FKDisclosureIndicatorAccessoryField class];
        _sliderFieldClass = [FKSliderField class];
        _buttonFieldClass = [FKButtonField class];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithObjectClass:(Class)objectClass {
    self = [self init];
    if (self) {
        self.objectClass = objectClass;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)mappingForClass:(Class)objectClass block:(void(^)(FKFormMapping *mapping))block {
    FKFormMapping *formMapping = [[self alloc] initWithObjectClass:objectClass];
    block(formMapping);
    return formMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (FKFormAttributeMapping *)mapAttribute:(NSString *)attribute title:(NSString *)title {
    return [self mapAttribute:attribute title:title type:FKFormAttributeMappingTypeDefault];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (FKFormAttributeMapping *)mapAttribute:(NSString *)attribute
                                   title:(NSString *)title
                                    type:(FKFormAttributeMappingType)type {
    
    return [self mapAttribute:attribute title:title type:type controllerClass:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (FKFormAttributeMapping *)mapAttribute:(NSString *)attribute
                                   title:(NSString *)title
                                    type:(FKFormAttributeMappingType)type
                            keyboardType:(UIKeyboardType)keyboardType {
    
    FKFormAttributeMapping *attributeMapping = [self attributeMappingWithTitle:title
                                                                     attribute:attribute
                                                                          type:type];
    
    attributeMapping.keyboardType = keyboardType;
    
    return attributeMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (FKFormAttributeMapping *)mapAttribute:(NSString *)attribute
                                   title:(NSString *)title
                         placeholderText:(NSString *)placeholderText
                                    type:(FKFormAttributeMappingType)type {
    
    FKFormAttributeMapping *attributeMapping = [self attributeMappingWithTitle:title
                                                                     attribute:attribute
                                                                          type:type];
    
    attributeMapping.placeholderText = placeholderText;
    
    return attributeMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (FKFormAttributeMapping *)mapAttribute:(NSString *)attribute
                                   title:(NSString *)title
                                    type:(FKFormAttributeMappingType)type
                         controllerClass:(Class)controllerClass {
    
    FKFormAttributeMapping *attributeMapping = [self attributeMappingWithTitle:title
                                                                     attribute:attribute
                                                                          type:type];
    
    attributeMapping.controllerClass = controllerClass;
    
    return attributeMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (FKFormAttributeMapping *)mapSliderAttribute:(NSString *)attribute
                                         title:(NSString *)title
                                      minValue:(float)minValue
                                      maxValue:(float)maxValue
                                    valueBlock:(FKFormMappingSliderValueBlock)valueBlock {
    
    FKFormAttributeMapping *attributeMapping = [self attributeMappingWithTitle:title
                                                                     attribute:attribute
                                                                          type:FKFormAttributeMappingTypeSlider];
    
    attributeMapping.minValue = minValue;
    attributeMapping.maxValue = maxValue;
    attributeMapping.sliderValueBlock = valueBlock;
    
    return attributeMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (FKFormAttributeMapping *)mapAttribute:(NSString *)attribute
                                   title:(NSString *)title
                                    type:(FKFormAttributeMappingType)type
                         dateFormatBlock:(FKFormMappingDateFormatBlock)dateFormatBlock {
    
    FKFormAttributeMapping *attributeMapping = [self attributeMappingWithTitle:title
                                                                     attribute:attribute
                                                                          type:type];
    
    attributeMapping.dateFormatBlock = dateFormatBlock;
    
    return attributeMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (FKFormAttributeMapping *)mapAttribute:(NSString *)attribute
                                   title:(NSString *)title
                                    type:(FKFormAttributeMappingType)type
                              dateFormat:(NSString *)dateFormat {
    
    FKFormAttributeMapping *attributeMapping = [self attributeMappingWithTitle:title
                                                                     attribute:attribute
                                                                          type:type];
    
    attributeMapping.dateFormat = dateFormat;
    
    return attributeMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (FKFormAttributeMapping *)mapAttribute:(NSString *)attribute
                                   title:(NSString *)title
                            showInPicker:(BOOL)showInPicker
                       selectValuesBlock:(FKFormMappingSelectValueBlock)selectValueBlock
                    valueFromSelectBlock:(FKFormMappingValueFromSelectBlock)valueFromSelectBlock
                         labelValueBlock:(FKFormMappingSelectLabelValueBlock)labelValue {
    
    FKFormAttributeMapping *attributeMapping = [self attributeMappingWithTitle:title
                                                                     attribute:attribute
                                                                          type:FKFormAttributeMappingTypeSelect];
    
    attributeMapping.selectValuesBlock = selectValueBlock;
    attributeMapping.valueFromSelectBlock = valueFromSelectBlock;
    attributeMapping.labelValueBlock = labelValue;
    attributeMapping.showInPicker = showInPicker;
    
    return attributeMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (FKFormAttributeMapping *)mapCustomCell:(Class)cell
                               identifier:(NSString *)identifier
                     willDisplayCellBlock:(FKFormMappingWillDisplayCellBlock)willDisplayCellBlock
                           didSelectBlock:(FKFormMappingCellSelectionBlock)selectionBlock {
    
    return [self mapCustomCell:cell
                    identifier:identifier
                     rowHeight:0
          willDisplayCellBlock:willDisplayCellBlock
                didSelectBlock:selectionBlock];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (FKFormAttributeMapping *)mapCustomCell:(Class)cell
                               identifier:(NSString *)identifier
                                rowHeight:(CGFloat)rowHeight
                     willDisplayCellBlock:(FKFormMappingWillDisplayCellBlock)willDisplayCellBlock
                           didSelectBlock:(FKFormMappingCellSelectionBlock)selectionBlock {
    
    FKFormAttributeMapping *attributeMapping = [self attributeMappingWithTitle:nil
                                                                     attribute:identifier
                                                                          type:FKFormAttributeMappingTypeCustomCell];
    
    attributeMapping.willDisplayCellBlock = willDisplayCellBlock;;
    attributeMapping.cellSelectionBlock = selectionBlock;
    attributeMapping.customCell = cell;
    attributeMapping.rowHeight = rowHeight;
    
    return attributeMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (FKFormAttributeMapping *)button:(NSString *)title
                        identifier:(NSString *)identifier
                           handler:(FKFormMappingButtonHandlerBlock)blockHandler
                      accesoryType:(UITableViewCellAccessoryType)accesoryType; {
    
    FKFormAttributeMapping *attributeMapping = [self attributeMappingWithTitle:title
                                                                     attribute:identifier
                                                                          type:FKFormAttributeMappingTypeButton];
    
    attributeMapping.btnHandler = blockHandler;
    attributeMapping.accesoryType = accesoryType;
    self.saveAttribute = attributeMapping;
    
    return attributeMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (FKFormAttributeMapping *)buttonSave:(NSString *)title handler:(FKBasicBlock)blockHandler {
    [self sectionWithTitle:@"" identifier:@"saveSection"];
    
    FKFormAttributeMapping *attributeMapping = [self attributeMappingWithTitle:title
                                                                     attribute:@"save"
                                                                          type:FKFormAttributeMappingTypeSaveButton];
    
    attributeMapping.saveBtnHandler = blockHandler;    
    self.saveAttribute = attributeMapping;
    
    return attributeMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)sectionWithTitle:(NSString *)title identifier:(NSString *)identifier {
    [self sectionWithTitle:title footer:nil identifier:identifier];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)sectionWithTitle:(NSString *)title footer:(NSString *)footer identifier:(NSString *)identifier {
    FKSectionObject *section = [FKSectionObject sectionWithHeaderTitle:(title ? title : @"")
                                                           footerTitle:footer];
    
    NSString *convertedIdentifier = [NSString stringWithFormat:@"section-%@", identifier];
    
    [_sectionTitles setObject:section forKey:convertedIdentifier];
    [self addFieldToOrdersArray:convertedIdentifier];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mappingForAttribute:(NSString *)attribute
                      title:(NSString *)title
                       type:(FKFormAttributeMappingType)type
           attributeMapping:(FKFormMappingAttributeMappingBlock)attributeMappingBlock {
    
    FKFormAttributeMapping *attributeMapping = [self attributeMappingWithTitle:title attribute:attribute type:type];
    attributeMappingBlock(attributeMapping);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)validationForAttribute:(NSString *)attribute
                    validBlock:(FKFormMappingIsValueValidBlock)validBlock {
    
    [self validationForAttribute:attribute validBlock:validBlock errorMessageBlock:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)validationForAttribute:(NSString *)attribute
                    validBlock:(FKFormMappingIsValueValidBlock)validBlock
             errorMessageBlock:(FKFormMappingFieldErrorStringBlock)errorMessageBlock {
    
    FKFormAttributeValidation *attributeValidation = [FKFormAttributeValidation attributeValidation];
    attributeValidation.attribute = attribute;
    attributeValidation.valueValidBlock = validBlock;
    attributeValidation.errorMessageBlock = errorMessageBlock;
    [_attributeValidations setObject:attributeValidation forKey:attribute];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Getters and setters


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary *)attributeMappings {
    return _attributeMappings;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary *)sectionTitles {
    return _sectionTitles;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (FKFormAttributeMapping *)attributeMappingWithTitle:(NSString *)title
                                            attribute:(NSString *)attribute
                                                 type:(FKFormAttributeMappingType)type {
    
    FKFormAttributeMapping *attributeMapping = [FKFormAttributeMapping attributeMapping];
    attributeMapping.title = title;
    attributeMapping.attribute = attribute;
    attributeMapping.type = type;
    [self addAttributeMappingToFormMapping:attributeMapping];
    
    return attributeMapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addFieldToOrdersArray:(NSString *)identifier {
    if ([self.fieldsOrder isKindOfClass:[NSMutableArray class]]) {
        [(NSMutableArray *)self.fieldsOrder addObject:identifier];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addAttributeMappingToFormMapping:(FKFormAttributeMapping *)attributeMapping {
    [_attributeMappings setObject:attributeMapping forKey:attributeMapping.attribute];
    [self addFieldToOrdersArray:attributeMapping.attribute];
}


@end
