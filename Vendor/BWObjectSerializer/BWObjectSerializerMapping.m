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

#import "BWObjectSerializerMapping.h"

#import "BWObjectSerializerAttributeMapping.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BWObjectSerializerMapping ()

- (void)addAttributeMappingToObjectMapping:(BWObjectSerializerAttributeMapping *)attributeMapping;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BWObjectSerializerMapping

@synthesize objectClass = _objectClass;
@synthesize attributeMappings = _attributeMappings;
@synthesize rootKeyPath = _rootKeyPath;


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
+ (id)mappingForObject:(Class)objectClass block:(void(^)(BWObjectSerializerMapping *serializer))block {
    BWObjectSerializerMapping *mapping = [[self alloc] initWithObjectClass:objectClass];
    block(mapping);
    return mapping;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapKeyPath:(NSString *)keyPath toAttribute:(NSString *)attribute {
    BWObjectSerializerAttributeMapping *attributeMapping = [BWObjectSerializerAttributeMapping attributeMapping];
    attributeMapping.keyPath = keyPath;
    attributeMapping.attribute = attribute;
    
    [self addAttributeMappingToObjectMapping:attributeMapping];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapKeyPath:(NSString *)keyPath toAttribute:(NSString *)attribute withDateFormat:(NSString *)dateFormat {
    BWObjectSerializerAttributeMapping *attributeMapping = [BWObjectSerializerAttributeMapping attributeMapping];
    attributeMapping.keyPath = keyPath;
    attributeMapping.attribute = attribute;
    attributeMapping.dataFormat = dateFormat;
    
    [self addAttributeMappingToObjectMapping:attributeMapping];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapKeyPath:(NSString *)keyPath
       toAttribute:(NSString *)attribute
       valueBlock:(BWObjectSerializeValueBlock)valueBlock {
    
    BWObjectSerializerAttributeMapping *attributeMapping = [BWObjectSerializerAttributeMapping attributeMapping];
    attributeMapping.keyPath = keyPath;
    attributeMapping.attribute = attribute;
    attributeMapping.valueBlock = valueBlock;
    
    [self addAttributeMappingToObjectMapping:attributeMapping];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addAttributeMappingToObjectMapping:(BWObjectSerializerAttributeMapping *)attributeMapping {
    [self.attributeMappings setObject:attributeMapping forKey:attributeMapping.attribute];
}


@end
