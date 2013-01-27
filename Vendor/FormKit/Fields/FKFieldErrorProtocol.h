//
//  FKFieldErrorProtocol.h
//  FormKitDemo
//
//  Created by cesar4 on 14/12/12.
//
//

#import <Foundation/Foundation.h>

@protocol FKFieldErrorProtocol <NSObject>

@required

- (void)addError:(NSString *)error;

- (void)setErrorTextColor:(UIColor *)color;

- (void)setErrorBackgroundColor:(UIColor *)color;

+ (CGFloat)errorHeightWithError:(NSString *)error tableView:(UITableView *)tableView;

@end
