//
// Created by Bruno Wernimont on 2012
// Copyright 2012 TableKit
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

#import "TKBlocks.h"

typedef enum {
    TKCellAttributeMappingTypeDefault = 0,
} TKCellAttributeMappingType;

@interface TKCellAttributeMapping : NSObject

/**
 Not used yet
 */
@property (nonatomic, assign) TKCellAttributeMappingType mappingType;

/**
 A string value that represent the keyPath from the model
 */
@property (nonatomic, copy) NSString *keyPath;

/**
 A string value that represent the attribute from the cell
 */
@property (nonatomic, copy) NSString *attribute;

/**
 Block that receive the value of keyPath
 @return Must return the value that we're going to set on the cell
 */
@property (nonatomic, copy) TKCellValueBlock valueBlock;

/**
 Block that receive the value of keyPath and the object itself
 @return Must return the value that we're going to set on the cell
 */
@property (nonatomic, copy) TKCellObjectBlock objectBlock;


/*
 * Convenient method to get an attributeMapping
 */
+ (id)attributeMapping;

@end
