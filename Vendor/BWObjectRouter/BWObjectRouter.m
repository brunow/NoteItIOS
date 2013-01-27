//
// Created by Bruno Wernimont on 2012
// Copyright 2012 BWObjectRouter
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

#import "BWObjectRouter.h"

#import "SOCKit.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BWObjectRouter ()

@property (nonatomic, strong) NSMutableDictionary *objectsRoutes;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BWObjectRouter

@synthesize objectsRoutes;


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        self.objectsRoutes = [NSMutableDictionary dictionary];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BWObjectRouter *)shared {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)routeObjectClass:(Class)objectClass toResourcePath:(NSString *)resourcePath forMethod:(BWObjectRouterMethod)method {
    NSString *stringObjectName = NSStringFromClass(objectClass);
    BWObjectRoutes *objectRoutes = [self.objectsRoutes objectForKey:stringObjectName];
    
    if (nil == objectRoutes) {
        objectRoutes = [BWObjectRoutes objectRoutesForObjectClass:objectClass];
        [self.objectsRoutes setObject:objectRoutes forKey:stringObjectName];
    }
    
    [objectRoutes addResourcePath:resourcePath forMethod:method];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)resourcePathForMethod:(BWObjectRouterMethod)method withObject:(id)object {
    NSString *objectStringClass = NSStringFromClass([object class]);
    BWObjectRoutes *objectRoutes = [self.objectsRoutes objectForKey:objectStringClass];
    NSString *patternResourcePath = [objectRoutes resourcePathForMethod:method];
    SOCPattern *pattern = [SOCPattern patternWithString:patternResourcePath];
    return [pattern stringFromObject:object];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)resourcePathForMethod:(BWObjectRouterMethod)method withObjectClass:(Class)objectClass {
    NSString *objectStringClass = NSStringFromClass(objectClass);
    BWObjectRoutes *objectRoutes = [self.objectsRoutes objectForKey:objectStringClass];
    return [objectRoutes resourcePathForMethod:method];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)resourcePathForMethod:(BWObjectRouterMethod)method withObjectClass:(Class)objectClass valueObject:(id)object {
    NSString *objectStringClass = NSStringFromClass(objectClass);
    BWObjectRoutes *objectRoutes = [self.objectsRoutes objectForKey:objectStringClass];
    NSString *patternResourcePath = [objectRoutes resourcePathForMethod:method];
    SOCPattern *pattern = [SOCPattern patternWithString:patternResourcePath];
    return [pattern stringFromObject:object];
}


@end
