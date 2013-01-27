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

#import "BWObjectMapping.h"

#import "BWObjectAttributeMapping.h"
#import "BWObjectMapper.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BWObjectMapping ()

@property (nonatomic, strong) NSDictionary *mappingDictionary;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BWObjectMapping


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithObjectClass:(Class)objectClass {
    self = [self init];
    if (self) {
        self.objectClass = objectClass;
        _attributeMappings = [[NSMutableDictionary alloc] init];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)mappingForObject:(Class)objectClass block:(void(^)(BWObjectMapping *mapping))block {
    BWObjectMapping *mapping = [[self alloc] initWithObjectClass:objectClass];
    block(mapping);
    return mapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapPrimaryKeyAttribute:(NSString *)primaryKey toAttribute:(NSString *)attribute {
    BWObjectAttributeMapping *attributeMapping = [BWObjectAttributeMapping attributeMapping];
    attributeMapping.keyPath = primaryKey;
    attributeMapping.attribute = attribute;
    
    self.primaryKeyAttribute = attributeMapping;
    [self addAttributeMappingToObjectMapping:attributeMapping];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapKeyPath:(NSString *)keyPath toAttribute:(NSString *)attribute {
    BWObjectAttributeMapping *attributeMapping = [BWObjectAttributeMapping attributeMapping];
    attributeMapping.keyPath = keyPath;
    attributeMapping.attribute = attribute;
    
    [self addAttributeMappingToObjectMapping:attributeMapping];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapKeyPath:(NSString *)keyPath toAttribute:(NSString *)attribute dateFormat:(NSString *)dateFormat {
    BWObjectAttributeMapping *attributeMapping = [BWObjectAttributeMapping attributeMapping];
    attributeMapping.keyPath = keyPath;
    attributeMapping.attribute = attribute;
    attributeMapping.dateFormat = dateFormat;
    
    [self addAttributeMappingToObjectMapping:attributeMapping];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapKeyPath:(NSString *)keyPath
       toAttribute:(NSString *)attribute
        valueBlock:(BWObjectMappingValueBlock)valueBlock {
    
    BWObjectAttributeMapping *attributeMapping = [BWObjectAttributeMapping attributeMapping];
    attributeMapping.keyPath = keyPath;
    attributeMapping.attribute = attribute;
    attributeMapping.valueBlock = valueBlock;
    
    [self addAttributeMappingToObjectMapping:attributeMapping];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapAttributeFromArray:(NSArray *)attributes {
    [attributes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self mapKeyPath:obj toAttribute:obj];
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapAttributeFromDictionary:(NSDictionary *)attributes {
    [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self mapKeyPath:key toAttribute:obj];
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)hasMany:(Class)relationClass withRootKeyPath:(NSString *)relationKeyPath {
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)hasOne:(Class)relationClass withRootKeyPath:(NSString *)relationKeyPath {
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)hasOne:(Class)relationClass {
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addAttributeMappingToObjectMapping:(BWObjectAttributeMapping *)attributeMapping {
    [self.attributeMappings setObject:attributeMapping forKey:attributeMapping.attribute];
}


@end
