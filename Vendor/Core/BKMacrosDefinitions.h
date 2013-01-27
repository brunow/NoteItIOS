//
// Created by Bruno Wernimont on 2012
// Copyright 2012 BaseKit
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
#import <objc/runtime.h>

#define BK_HAS_ARC __has_feature(objc_arc)
#define BK_HAS_WEAK __has_feature(objc_arc_weak)

#if BK_HAS_WEAK
    #define BK_PROP_WEAK             weak
    #define BK_WEAK_IVAR             __weak
#else
    #define BK_PROP_WEAK             unsafe_unretained
    #define BK_WEAK_IVAR             __unsafe_unretained
#endif


#define BK_RGBA_COLOR(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define BK_RGB_COLOR(r, g, b) BK_RGBA_COLOR(r, g, b, 1)

/**
 * Return the app delegate shared instance.
 * Expected that the app delegate is named AppDelegate
 */
#define AppDelegateSharedInstance ((AppDelegate *)[[UIApplication sharedApplication] delegate])


// Time saving shortcuts
#define BK_BOOLEAN(val) [NSNumber numberWithBool:val]
#define BK_NULL [NSNull null]
#define BK_INT(val) [NSNumber numberWithInt:val]
#define BK_INTEGER(val) [NSNumber numberWithInteger:val]
#define BK_FLOAT(val) [NSNumber numberWithFloat:val]

#define BK_ADD_DYNAMIC_PROPERTY(TYPE, NAME, SETTER_NAME) \
static char key##NAME; \
@dynamic NAME; \
\
- (void)SETTER_NAME:(TYPE)NAME { \
    objc_setAssociatedObject(self, &key##NAME, \
                             NAME, \
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
} \
\
- (TYPE)NAME { \
    return objc_getAssociatedObject(self, &key##NAME); \
}


#define BK_ADD_SHARED_INSTANCE_USING_BLOCK(BLOCK) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
\
dispatch_once(&pred, ^{ \
    _sharedObject = BLOCK(); \
}); \
\
return _sharedObject; \
