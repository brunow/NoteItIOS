//
//  BKUtils.m
//  TrackingNumber
//
//  Created by Bruno Wernimont on 10/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BKUtils.h"


////////////////////////////////////////////////////////////////////////////////////////////////////
NSString* BKPrimaryKeyAttributeForClass(Class klass) {
    NSString *className = NSStringFromClass(klass);
    className = [className stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                   withString:[[className substringToIndex:1] lowercaseString]];
    
    return [className stringByAppendingString:@"ID"];
}
