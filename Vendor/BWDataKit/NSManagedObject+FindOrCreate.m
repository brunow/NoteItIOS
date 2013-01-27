//
// Created by Bruno Wernimont on 2013
// Copyright 2012 BWDataKit
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
// Inspired by the great https://github.com/soffes/ssdatakit
//

#import "NSManagedObject+FindOrCreate.h"

#import "CoreData+MagicalRecord.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSManagedObject (FindOrCreate)


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (id) MR_findOrCreateByAttribute:(NSString *)attribute value:(id)value
{
    return [self MR_findOrCreateByAttribute:attribute
                                      value:value
                                  inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (id) MR_findOrCreateByAttribute:(NSString *)attribute value:(id)value inContext:(NSManagedObjectContext *)context
{
    id object = [self MR_findFirstByAttribute:attribute withValue:value];
    
    if (nil == object)
        {
        object = [self MR_createInContext:context];
        [object setValue:value forKey:attribute];
        }
    
    return object;
}


@end
