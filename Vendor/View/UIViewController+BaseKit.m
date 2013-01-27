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

#import "UIViewController+BaseKit.h"

#import "BKMacrosDefinitions.h"


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UIViewController (BaseKit)


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)presentModalViewControllerWithBlock:(BKViewControllerBlock)viewController
                       navigationController:(BOOL)navigationController
                                   animated:(BOOL)animated {
    
    if (navigationController) {
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:viewController()];
        [self presentViewController:nc animated:animated completion:nil];
    } else {
        [self presentViewController:viewController() animated:animated completion:nil];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)presentModalViewControllerWithBlock:(BKViewControllerBlock)viewController
                                   animated:(BOOL)animated {
    
    [self presentModalViewControllerWithBlock:viewController
                         navigationController:YES
                                     animated:animated];
}


@end
