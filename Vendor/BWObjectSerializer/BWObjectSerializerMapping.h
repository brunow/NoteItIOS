//
// Created by Bruno Wernimont on 2012
// Copyright 2012 BWObjectSerializer
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

#import "BWObjectSerializerBlocks.h"

@interface BWObjectSerializerMapping : NSObject

@property (nonatomic, assign) Class objectClass;
@property (nonatomic, readonly, strong) NSMutableDictionary *attributeMappings;

/**
 Object json root key path
 */
@property (nonatomic, copy) NSString *rootKeyPath;

- (id)initWithObjectClass:(Class)objectClass;

/**
 Create a mapping serializer
 @param objectClass The class that you want to serialize
 */
+ (id)mappingForObject:(Class)objectClass block:(void(^)(BWObjectSerializerMapping *serializer))block;

/**
 Add an attribute mapping to the serializer
 @param keyPath The object keypath
 @param attribute The name of dictionary key
 */
- (void)mapKeyPath:(NSString *)keyPath toAttribute:(NSString *)attribute;

/**
 Add an attribute mapping to the serializer
 @param keyPath The object keypath
 @param attribute The name of dictionary key
 @param dateFormat Specific date format for this attribute
 */
- (void)mapKeyPath:(NSString *)keyPath toAttribute:(NSString *)attribute withDateFormat:(NSString *)dateFormat;

/**
 Add an attribute mapping to the serializer
 @param keyPath The object keypath
 @param attribute The name of dictionary key
 @param valueBlock Before add value to the dictionary you can perform some action on the value
 */
- (void)mapKeyPath:(NSString *)keyPath
       toAttribute:(NSString *)attribute
       valueBlock:(BWObjectSerializeValueBlock)valueBlock;

@end
