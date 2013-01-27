//
//  NSAttributedString+Markdown.m
//  Cocktail
//
//  Created by Daniel Eggert on 1/13/12.
//  Copyright (c) 2012 SHAPE ApS. All rights reserved.
//  Copyright (c) 2012 Daniel Eggert / Bödewadt. All rights reserved.
//

#import "NSAttributedString+Markdown.h"

#import <libkern/OSAtomic.h>
#import <UIKit/UIKit.h>



@implementation NSMutableAttributedString (BOMarkers)

- (void)addAttributes:(NSDictionary *)attributes toRangeWithStartMarker:(NSString *)startMarker endMarker:(NSString *)endMarker;
{
    [self addAttributes:attributes toRangeWithStartMarker:startMarker endMarker:endMarker fontBlock:nil];
}

- (void)addAttributes:(NSDictionary *)attributes toRangeWithStartMarker:(NSString *)startMarker endMarker:(NSString *)endMarker fontBlock:(BOFontReplacementBlock_t)fontBlock;
{
    NSMutableString *string = [self mutableString];
    NSRange remainingRange = NSMakeRange(0, [string length]);
    while (0 < remainingRange.length) {
        NSRange const startRange = [string rangeOfString:startMarker options:NSLiteralSearch range:remainingRange];
        if (startRange.length == 0) {
            break;
        } else {
            remainingRange = NSMakeRange(NSMaxRange(startRange), [string length] - NSMaxRange(startRange));
            NSRange const endRange = [string rangeOfString:endMarker options:NSLiteralSearch range:remainingRange];
            if (endRange.length == 0) {
                break;
            } else {
                remainingRange = NSMakeRange(NSMaxRange(endRange), [string length] - NSMaxRange(endRange));
                // Remove markers:
                [string replaceCharactersInRange:endRange withString:@""];
                [string replaceCharactersInRange:startRange withString:@""];
                remainingRange.location -= startRange.length + endRange.length;
                // Set style:
                NSRange styleRange = NSMakeRange(startRange.location, endRange.location - startRange.location - startRange.length);
                if (attributes != nil) {
                    [self addAttributes:attributes range:styleRange];
                }
                if (fontBlock != nil) {
                    [self enumerateAttribute:NSFontAttributeName inRange:styleRange options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(UIFont *originalFont, NSRange fontRange, BOOL *stop)
                     {
                         (void) stop;
                         UIFont *newFont = fontBlock(originalFont);
                         [self addAttributes:@{NSFontAttributeName: newFont} range:fontRange];
                     }];
                }
            }
        }
    }
}

- (void)addAttributesToRangeWithStartMarker:(NSString *)startMarker endMarker:(NSString *)endMarker usingAttributesBlock:(NSDictionary * (^)(unichar marker))block fontBlock:(BOFontReplacementBlock_t)fontBlock;
{
    NSMutableString *string = [self mutableString];
    NSRange remainingRange = NSMakeRange(0, [string length]);
    while (0 < remainingRange.length) {
        NSRange startRange = [string rangeOfString:startMarker options:NSLiteralSearch range:remainingRange];
        if (startRange.length == 0) {
            break;
        } else {
            unichar const marker = [string characterAtIndex:NSMaxRange(startRange)];
            startRange.length += 1;
            
            remainingRange = NSMakeRange(NSMaxRange(startRange), [string length] - NSMaxRange(startRange));
            NSRange const endRange = [string rangeOfString:endMarker options:NSLiteralSearch range:remainingRange];
            if (endRange.length == 0) {
                break;
            } else {
                remainingRange = NSMakeRange(NSMaxRange(endRange), [string length] - NSMaxRange(endRange));
                // Remove markers:
                [string replaceCharactersInRange:endRange withString:@""];
                [string replaceCharactersInRange:startRange withString:@""];
                remainingRange.location -= startRange.length + endRange.length;
                // Set style:
                NSRange styleRange = NSMakeRange(startRange.location, endRange.location - startRange.location - startRange.length);
                NSDictionary *attributes = block(marker);
                if (attributes != nil) {
                    [self addAttributes:attributes range:styleRange];
                }
                if (fontBlock != nil) {
                    [self enumerateAttribute:NSFontAttributeName inRange:styleRange options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(UIFont *originalFont, NSRange range, BOOL *stop)
                    {
                        (void) stop;
                        UIFont *newFont = fontBlock(originalFont);
                        [self addAttributes:@{NSFontAttributeName: newFont} range:range];
                    }];
                }
            }
        }
    }
}

- (void)enumerateAttribute:(NSString *)attrName inRangesWithStartMarker:(NSString *)startMarker endMarker:(NSString *)endMarker usingBlock:(void (^)(id value, NSRange range))block;
{
    NSMutableString *string = [self mutableString];
    NSRange remainingRange = NSMakeRange(0, [string length]);
    while (0 < remainingRange.length) {
        NSRange const startRange = [string rangeOfString:startMarker options:NSLiteralSearch range:remainingRange];
        if (startRange.length == 0) {
            break;
        } else {
            remainingRange = NSMakeRange(NSMaxRange(startRange), [string length] - NSMaxRange(startRange));
            NSRange const endRange = [string rangeOfString:endMarker options:NSLiteralSearch range:remainingRange];
            if (endRange.length == 0) {
                break;
            } else {
                remainingRange = NSMakeRange(NSMaxRange(endRange), [string length] - NSMaxRange(endRange));
                // Remove markers:
                [string replaceCharactersInRange:endRange withString:@""];
                [string replaceCharactersInRange:startRange withString:@""];
                remainingRange.location -= startRange.length + endRange.length;
                // Set style:
                NSRange styleRange = NSMakeRange(startRange.location, endRange.location - startRange.location - startRange.length);
                [self enumerateAttribute:attrName inRange:styleRange options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
                    (void) stop;
                    block(value, range);
                }];
            }
        }
    }
}

- (void)updateFontAttributeInRangesWithStartMarker:(NSString *)startMarker endMarker:(NSString *)endMarker usingBlock:(BOFontReplacementBlock_t)block;
{
    [self enumerateAttribute:NSFontAttributeName inRangesWithStartMarker:startMarker endMarker:endMarker usingBlock:^(UIFont *originalFont, NSRange range) {
        UIFont *newFont = block(originalFont);
        if (newFont != nil) {
            [self addAttributes:@{NSFontAttributeName: newFont} range:range];
        }
    }];
}

@end
