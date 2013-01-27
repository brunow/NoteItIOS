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

#import "BWObjectRoutes.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BWObjectRoutes ()

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BWObjectRoutes

@synthesize objectClass;
@synthesize resourcePaths = _resourcePaths;


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        _resourcePaths = [NSMutableDictionary dictionary];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (BWObjectRoutes *)objectRoutesForObjectClass:(Class)class {
    BWObjectRoutes *route = [[self alloc] init];
    route.objectClass = class;
    return route;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addResourcePath:(NSString *)resourcePath forMethod:(BWObjectRouterMethod)method {
    if (BWObjectRouterMethodAllExceptPOST == method) {
        [self addResourcePath:resourcePath forMethod:BWObjectRouterMethodDELETE];
        [self addResourcePath:resourcePath forMethod:BWObjectRouterMethodGET];
        [self addResourcePath:resourcePath forMethod:BWObjectRouterMethodPUT];
    } else {
        [self.resourcePaths setObject:resourcePath forKey:[NSNumber numberWithInt:method]];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)resourcePathForMethod:(BWObjectRouterMethod)method {
    return [self.resourcePaths objectForKey:[NSNumber numberWithInt:method]];
}


@end
