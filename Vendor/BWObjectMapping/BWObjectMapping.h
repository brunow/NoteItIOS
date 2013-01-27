//
// Created by Bruno Wernimont on 2012
// Copyright 2012 BWObjectMapping
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

#import "BWObjectMappingBlocks.h"

@class BWObjectAttributeMapping;

@interface BWObjectMapping : NSObject

@property (nonatomic, assign) Class objectClass;
@property (nonatomic, readonly, strong) NSMutableDictionary *attributeMappings;
@property (nonatomic, strong) BWObjectAttributeMapping *primaryKeyAttribute;
@property (nonatomic, strong) NSString *rootKeyPath;

- (id)initWithObjectClass:(Class)objectClass;

+ (id)mappingForObject:(Class)objectClass block:(void(^)(BWObjectMapping *mapping))block;

- (void)mapPrimaryKeyAttribute:(NSString *)primaryKey toAttribute:(NSString *)attribute;

- (void)mapAttributeFromDictionary:(NSDictionary *)attributes;

- (void)mapAttributeFromArray:(NSArray *)attributes;

- (void)mapKeyPath:(NSString *)keyPath toAttribute:(NSString *)attribute;

- (void)mapKeyPath:(NSString *)keyPath toAttribute:(NSString *)attribute dateFormat:(NSString *)dateFormat;

- (void)mapKeyPath:(NSString *)keyPath
       toAttribute:(NSString *)attribute
        valueBlock:(BWObjectMappingValueBlock)valueBlock;

- (void)hasMany:(Class)relationClass withRootKeyPath:(NSString *)relationKeyPath;

- (void)hasOne:(Class)relationClass withRootKeyPath:(NSString *)relationKeyPath;

- (void)hasOne:(Class)relationClass;

@end
