//
//  NSAttributedString+Markdown.h
//  Cocktail
//
//  Created by Daniel Eggert on 1/13/12.
//  Copyright (c) 2012 SHAPE ApS. All rights reserved.
//  Copyright (c) 2012 Daniel Eggert / Bödewadt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BOMarkdownParser.h"




@interface NSMutableAttributedString (BOMarkers)

- (void)addAttributes:(NSDictionary *)attributes toRangeWithStartMarker:(NSString *)startMarker endMarker:(NSString *)endMarker;
- (void)addAttributes:(NSDictionary *)attributes toRangeWithStartMarker:(NSString *)startMarker endMarker:(NSString *)endMarker fontBlock:(BOFontReplacementBlock_t)fontBlock;

- (void)addAttributesToRangeWithStartMarker:(NSString *)startMarker endMarker:(NSString *)endMarker usingAttributesBlock:(NSDictionary * (^)(unichar marker))block fontBlock:(BOFontReplacementBlock_t)fontBlock;

- (void)enumerateAttribute:(NSString *)attrName inRangesWithStartMarker:(NSString *)startMarker endMarker:(NSString *)endMarker usingBlock:(void (^)(id value, NSRange range))block;

- (void)updateFontAttributeInRangesWithStartMarker:(NSString *)startMarker endMarker:(NSString *)endMarker usingBlock:(BOFontReplacementBlock_t)block;

@end
