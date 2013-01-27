//
//  DKPropertyList.m
//  DiscoKit
//
//  Created by Keith Pitt on 12/06/11.
//  Copyright 2011 Mostly Disco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKPropertyList : NSObject {
	
	NSString * _plistPath;
    NSArray * _properties;

}

+ (void)setValue:(id)value forProperty:(NSString *)property;
+ (id)valueForProperty:(NSString *)property;

- (void)save;
- (void)reset;
- (void)reload;

@end