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

#import "BKToogleValue.h"

#import "BKMacrosDefinitions.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BKToogleValue

@synthesize firstValue = _firstValue;
@synthesize secondValue = _secondValue;
@synthesize isFirstValueSelected = _isFirstValueSelected;


////////////////////////////////////////////////////////////////////////////////
+ (id)firstValue:(id)firstValue secondValue:(id)secondValue {
    BKToogleValue *toogleValue = [[self alloc] initWithFirstValue:firstValue secondValue:secondValue];
    return toogleValue;
}


////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        self.isFirstValueSelected = YES;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////
- (id)initWithFirstValue:(id)firstValue secondValue:(id)secondValue {
    self = [self init];
    if (self) {
        self.firstValue = firstValue;
        self.secondValue = secondValue;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////
- (void)toggle {
    self.isFirstValueSelected = !self.isFirstValueSelected;
}


////////////////////////////////////////////////////////////////////////////////
- (id)currentValue {
    return self.isFirstValueSelected ? self.firstValue : self.secondValue;
}


////////////////////////////////////////////////////////////////////////////////
- (void)setCurrentValue:(id)currentValue {
    self.isFirstValueSelected = (currentValue == self.firstValue);
}

@end
