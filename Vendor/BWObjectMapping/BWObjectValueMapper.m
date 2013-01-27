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

#import "BWObjectValueMapper.h"

#import "BWObjectMapper.h"
#import "BWObjectMappingBlocks.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BWObjectValueMapper ()

- (NSDate *)parseDateValue:(NSString *)value withAttributeMapping:(BWObjectAttributeMapping *)attributeMapping;

- (id)transformValue:(id)value withValueBlock:(BWObjectMappingValueBlock)valueBlock fromObject:(id)object;

- (id)transformValue:(id)value forKeyPath:(NSString *)keyPath withCoreDataObject:(NSManagedObject *)object;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BWObjectValueMapper


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BWObjectValueMapper *)shared {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setValue:(id)value
      forKeyPath:(NSString *)keyPath
withAttributeMapping:(BWObjectAttributeMapping *)attributeMapping
       forObject:(id)object {
    
    if (nil == value || [NSNull class] == [value class]) {
        return;
    }
    
    id transformedValue = value;
    
    if ([value isKindOfClass:[NSString class]]) {
        NSDate *date = [self parseDateValue:value withAttributeMapping:attributeMapping];
        
        if (nil != date) {
            transformedValue = date;
        }
    }
    
    if (nil != attributeMapping.valueBlock) {
        transformedValue = [self transformValue:value
                                 withValueBlock:attributeMapping.valueBlock
                                     fromObject:object];
    }
    
    if ([object isKindOfClass:NSClassFromString(@"NSManagedObject")]) {
        transformedValue = [self transformValue:transformedValue forKeyPath:keyPath withCoreDataObject:object];
    }
    
    [object setValue:transformedValue forKeyPath:keyPath];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)transformValue:(id)value forKeyPath:(NSString *)keyPath withCoreDataObject:(NSManagedObject *)object {
    NSAttributeDescription *attributeDesc = [[[object entity] attributesByName] objectForKey:keyPath];
    
    id transformedValue = nil;
    
    if(nil == attributeDesc) {
        return value;
    }
    
    NSAttributeType attributeType = attributeDesc.attributeType;
    Class expectedClass = NSClassFromString(attributeDesc.attributeValueClassName);
    
    if(nil == value || [value isKindOfClass:expectedClass]) {
        return value;
    }
    
    switch (attributeType) {
        case NSBooleanAttributeType:
            if([value respondsToSelector:@selector(boolValue)])
                transformedValue = [NSNumber numberWithBool:[value boolValue]];
            break;
        case NSInteger16AttributeType :
        case NSInteger32AttributeType :
            if([value respondsToSelector:@selector(intValue)])
                transformedValue = [NSNumber numberWithLong:[value intValue]];
            break;
        case NSInteger64AttributeType :
            if([value respondsToSelector:@selector(longLongValue)])
                transformedValue = [NSNumber numberWithLongLong:[value longLongValue]];
            break;
        case NSDecimalAttributeType :
            if([value isKindOfClass:[NSString class]])
                transformedValue = [NSDecimalNumber decimalNumberWithString:value];
            break;
        case NSDoubleAttributeType :
            if([value respondsToSelector:@selector(doubleValue)])
                transformedValue = [NSNumber numberWithDouble:[value doubleValue]];
            break;
        case NSFloatAttributeType :
            if([value respondsToSelector:@selector(floatValue)])
                transformedValue = [NSNumber numberWithFloat:[value floatValue]];
            break;
        case NSStringAttributeType :
            if([value respondsToSelector:@selector(stringValue)])
                transformedValue = [value stringValue];
            break;
        case NSDateAttributeType :
        case NSBinaryDataAttributeType:
            break;
        case NSObjectIDAttributeType:
        case NSTransformableAttributeType:
            break;
        default :
            transformedValue = value;
            break;
    }
    
    return transformedValue;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)transformValue:(id)value withValueBlock:(BWObjectMappingValueBlock)valueBlock fromObject:(id)object {
    return valueBlock(value, object);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDate *)parseDateValue:(NSString *)value withAttributeMapping:(BWObjectAttributeMapping *)attributeMapping {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSString *dateFormat = nil;
    
    if (nil != attributeMapping.dateFormat) {
        dateFormat = attributeMapping.dateFormat;
    } else {
        dateFormat = [[BWObjectMapper shared] defaultDateFormat];
    }
    
    [dateFormatter setDateFormat:dateFormat];
    
    return [dateFormatter dateFromString:value];
}


@end
