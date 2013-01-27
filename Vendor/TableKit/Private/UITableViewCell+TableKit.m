//
// Created by Bruno Wernimont on 2012
// Copyright 2012 TableKit
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

#import "UITableViewCell+TableKit.h"


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UITableViewCell (TableKit)


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)cellForTableView:(UITableView *)tableView { 
    NSString *cellID = [self cellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        UITableViewCellStyle cellStyle = [self cellStyle];
        cell = [[self alloc] initWithStyle:cellStyle reuseIdentifier:cellID];
    }
    
    return cell;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib {
    NSString *cellID = [self cellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
        cell = [nibObjects objectAtIndex:0];
    }
    
    return cell;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (UITableViewCellStyle)cellStyle {
    return UITableViewCellStyleDefault;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (UINib *)nib {
    NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
    NSString *nibName = [self nibName];
    
    return [UINib nibWithNibName:nibName bundle:classBundle];
} 


////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)nibName {
    return [self cellIdentifier];
}


@end
