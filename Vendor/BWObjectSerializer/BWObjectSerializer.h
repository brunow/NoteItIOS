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

#import "BWObjectSerializerMapping.h"

@interface BWObjectSerializer : NSObject

/**
 Date format that will be used if no date format is specified on the mapping
 */
@property (nonatomic, strong) NSString *defaultDateFormat;

/**
 Shared instance
 */
+ (BWObjectSerializer *)shared;

/**
 Register an object serialize
 @param serializer Object serializer
 */
- (void)registerSerializer:(BWObjectSerializerMapping *)serializer;

/**
 Register an object serialize with a root json key path
 @param serializer Object serializer
 @param keyPath Root json key path thath will be used to known which serializer to use
 */
- (void)registerSerializer:(BWObjectSerializerMapping *)serializer withRootKeyPath:(NSString *)keyPath;

/**
 Serialize the object into a dictionary
 @param object Any object
 @param mapping The serializer to use to convert the object into dictionary
 */
- (NSDictionary *)serializeObject:(id)object withMapping:(BWObjectSerializerMapping *)mapping;


/**
 Serialize the object into a dictionary. You need to have added the right mapping serializer.
 @param object Any object mapped into the serialize
 */
- (NSDictionary *)serializeObject:(id)object;

@end
