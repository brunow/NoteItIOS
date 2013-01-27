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

#import "NSString+BaseKit.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSString (BaseKit)


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)stringByCapitalizingFirstLetter {
    NSRange firstLetterRange = NSMakeRange(0, 1);
    NSString *firstLetter = [[self substringWithRange:firstLetterRange] uppercaseString];
    
    return [self stringByReplacingCharactersInRange:firstLetterRange withString:firstLetter];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)stringByCamelizingString {
    NSArray *words = [self componentsSeparatedByString:@"_"];
    NSMutableString *camelizedString = [NSMutableString string];
    
    for (NSString *word in words) {
        NSString *capitalizedWord = [word stringByCapitalizingFirstLetter];
        
        [camelizedString appendString:capitalizedWord];
    }
    
    NSString *firstLetter = [[self substringToIndex:1] lowercaseString];    
    [camelizedString replaceCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
    
    return camelizedString;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)stringByUnderscoringWord {
    NSMutableString *word = [NSMutableString string];
    NSMutableString *strings = [NSMutableString string];
    
    for (NSInteger index = 0; index < self.length; index++) {
        NSRange letterRange = NSMakeRange(index, 1);
        NSString *character = [[self substringWithRange:letterRange] uppercaseString];
        BOOL isUppercase = [[NSCharacterSet uppercaseLetterCharacterSet]
                            characterIsMember:[self characterAtIndex:index]];
        
        if (isUppercase) {
            [strings appendFormat:@"_%@", [word lowercaseString]];
            word = [NSMutableString string];
        }
        
        [strings appendString:character];
    }
    
    return [strings lowercaseString];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)containString:(NSString *)string {
    return ([self rangeOfString:string].location == NSNotFound) ? NO : YES;
}


@end
