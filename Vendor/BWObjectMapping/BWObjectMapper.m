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

#import "BWObjectMapper.h"

#import "BWObjectAttributeMapping.h"
#import "BWObjectValueMapper.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BWObjectMapper ()

@property (nonatomic, strong) NSMutableDictionary *mappings;

- (void)mapDictionary:(NSDictionary *)dict toObject:(id)object withMapping:(BWObjectMapping *)mapping;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BWObjectMapper


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BWObjectMapper *)shared {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        self.mappings = [NSMutableDictionary dictionary];
        self.defaultDateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        
        self.objectBlock = ^id(Class objectClass, NSString *primaryKey, id primaryKeyValue, id JSON) {
            return [[objectClass alloc] init];
        };
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)registerMapping:(BWObjectMapping *)mapping {
    [self registerMapping:mapping withRootKeyPath:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)registerMapping:(BWObjectMapping *)mapping withRootKeyPath:(NSString *)keyPath {
    NSString *objectName = NSStringFromClass(mapping.objectClass);
    mapping.rootKeyPath = keyPath;
    [self.mappings setObject:mapping forKey:objectName];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)objectWithBlock:(BWObjectMappingObjectBlock)objectBlock {
    self.objectBlock = objectBlock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didMapObjectWithBlock:(BWObjectMappingObjectDidMapObjectBlock)didMapBlock {
    self.didMapObjectBlock = didMapBlock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)objectsFromJSON:(id)JSON withMapping:(BWObjectMapping *)mapping {
    NSMutableArray *objects = [NSMutableArray array];
    
    if ([JSON isKindOfClass:[NSArray class]]) {
        [JSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSArray *newObjects = [self objectsFromJSON:obj withMapping:mapping];
            [objects addObjectsFromArray:newObjects];
        }];
        
    } else if ([JSON isKindOfClass:[NSDictionary class]]) {
        id object = [self objectFromJSON:JSON withMapping:mapping];
        
        if (nil != objects)
            [objects addObject:object];
    }
        
    return [NSArray arrayWithArray:objects];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)objectsFromJSON:(id)JSON withObjectClass:(Class)objectClass {
    NSString *objectName = NSStringFromClass(objectClass);
    BWObjectMapping *mapping = [self.mappings objectForKey:objectName];
    return [self objectsFromJSON:JSON withMapping:mapping];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray *)objectsFromJSON:(id)JSON {
    NSMutableArray *objects = [NSMutableArray array];
    
    if ([JSON isKindOfClass:[NSArray class]]) {
        [JSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSArray *newObjects = [self objectsFromJSON:obj];
            [objects addObjectsFromArray:newObjects];
        }];
        
    } else if ([JSON isKindOfClass:[NSDictionary class]]) {
        [self.mappings enumerateKeysAndObjectsUsingBlock:^(id key, BWObjectMapping *objectMapping, BOOL *stop) {
            NSString *rootKeyPath = objectMapping.rootKeyPath;
            id rootKeyPathObject = [JSON objectForKey:rootKeyPath];
            
            if (nil != rootKeyPathObject) {
                NSArray *newbjects = [self objectsFromJSON:rootKeyPathObject withMapping:objectMapping];
                
                if (newbjects.count > 0)
                    [objects addObjectsFromArray:newbjects];
                
                *stop = YES;
            }
        }];
        
    }
    
    return [NSArray arrayWithArray:objects];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectFromJSON:(id)JSON withMapping:(BWObjectMapping *)mapping {
    return [self objectFromJSON:JSON withMapping:mapping existingObject:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectFromJSON:(id)JSON withMapping:(BWObjectMapping *)mapping existingObject:(id)object {
    id JSONToMap = [JSON objectForKey:mapping.rootKeyPath];
    
    if (nil == JSONToMap)
        JSONToMap = JSON;
    
    NSString *primaryKey = mapping.primaryKeyAttribute.attribute;
    id primaryKeyValue = [JSONToMap objectForKey:mapping.primaryKeyAttribute.keyPath];
    
    if (nil == object) {
        object = self.objectBlock(mapping.objectClass, primaryKey, primaryKeyValue, JSONToMap);
    }
    
    [self mapDictionary:JSONToMap toObject:object withMapping:mapping];
    
    return object;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectFromJSON:(id)JSON withObjectClass:(Class)objectClass {
    return [self objectFromJSON:JSON withObjectClass:objectClass existingObject:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectFromJSON:(id)JSON withObjectClass:(Class)objectClass existingObject:(id)object {
    NSString *objectName = NSStringFromClass(objectClass);
    BWObjectMapping *mapping = [self.mappings objectForKey:objectName];
    return [self objectFromJSON:JSON withMapping:mapping existingObject:object];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectFromJSON:(id)JSON {
    return [self objectFromJSON:JSON existingObject:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectFromJSON:(id)JSON existingObject:(id)object {
    __block id parsedObject = nil;
    [self.mappings enumerateKeysAndObjectsUsingBlock:^(id key, BWObjectMapping *objectMapping, BOOL *stop) {
        if (objectMapping.objectClass == [object class]) {
            parsedObject = [self objectFromJSON:JSON withMapping:objectMapping existingObject:object];
            
            *stop = YES;
        }
    }];
    
    return parsedObject;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)mapDictionary:(NSDictionary *)dict toObject:(id)object withMapping:(BWObjectMapping *)mapping {
    [mapping.attributeMappings enumerateKeysAndObjectsUsingBlock:^(id key, BWObjectAttributeMapping *attributeMapping, BOOL *stop) {
        [[BWObjectValueMapper shared] setValue:[dict valueForKeyPath:attributeMapping.keyPath]
                                    forKeyPath:attributeMapping.attribute
                             withAttributeMapping:attributeMapping
                                     forObject:object];
    }];
    
    if (nil != self.didMapObjectBlock) {
        self.didMapObjectBlock(object);
    }
}


@end
