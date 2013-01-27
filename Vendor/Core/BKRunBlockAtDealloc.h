//
//  BKRunBlockAtDealloc.h
//  BaseKit
//
//  Created by Bruno Wernimont on 25/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Original idea from http://blog.slaunchaman.com/2011/04/11/fun-with-the-objective-c-runtime-run-code-at-deallocation-of-any-object/
   Thanks to him !
 */

#import "BKBlocks.h"

@interface BKRunBlockAtDealloc : NSObject

@property (nonatomic, copy) BKBasicBlock block;

- (id)initWithBlock:(BKBasicBlock)block;

@end
