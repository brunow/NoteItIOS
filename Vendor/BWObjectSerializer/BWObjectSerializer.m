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

#import "BWObjectSerializer.h"

#import "BWObjectSerializerAttributeMapping.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BWObjectSerializer ()

@property (nonatomic, strong) NSMutableDictionary *serializers;

- (NSString *)formattedStringDate:(NSDate *)date usingFormat:(NSString *)dateFormat;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BWObjectSerializer

@synthesize serializers = _serializers;
@synthesize defaultDateFormat = _defaultDateFormat;


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BWObjectSerializer *)shared {
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
        self.serializers = [NSMutableDictionary dictionary];
        self.defaultDateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'"; // Rails date format
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)registerSerializer:(BWObjectSerializerMapping *)serializer {
    [self registerSerializer:serializer withRootKeyPath:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)registerSerializer:(BWObjectSerializerMapping *)serializer withRootKeyPath:(NSString *)keyPath {
    NSString *objectName = NSStringFromClass(serializer.objectClass);
    [self.serializers setObject:serializer forKey:objectName];
    serializer.rootKeyPath = keyPath;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary *)serializeObject:(id)object withMapping:(BWObjectSerializerMapping *)mapping {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [mapping.attributeMappings enumerateKeysAndObjectsUsingBlock:^(id key, BWObjectSerializerAttributeMapping *attributeMapping, BOOL *stop) {
        id value = [object valueForKeyPath:attributeMapping.keyPath];
        
        if (nil != attributeMapping.valueBlock) {
            value = attributeMapping.valueBlock(value, object);
        } else if ([value isKindOfClass:[NSDate class]]) {
            NSString *dateFormat = self.defaultDateFormat;
            
            if (nil != attributeMapping.dataFormat)
                dateFormat = attributeMapping.dataFormat;
            
            value = [self formattedStringDate:value usingFormat:dateFormat];
        }
        
        if ([value isKindOfClass:[NSString class]] && [(NSString *)value length] == 0) {
            value = nil;
        }
        
        if (nil != value) {
            [params setObject:value forKey:attributeMapping.attribute];
        }
    }];
    
    return (nil == mapping.rootKeyPath)
        ? params : [NSDictionary dictionaryWithObject:params forKey:mapping.rootKeyPath];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary *)serializeObject:(id)object {
    NSString *objectName = NSStringFromClass([object class]);
    BWObjectSerializerMapping *mapping = [self.serializers objectForKey:objectName];
    return [self serializeObject:object withMapping:mapping];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)formattedStringDate:(NSDate *)date usingFormat:(NSString *)dateFormat {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    [formatter setCalendar:cal];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *stringDate = [formatter stringFromDate:date];
    return stringDate;
}


@end
