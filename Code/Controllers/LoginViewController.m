//
// Created by Bruno Wernimont on 2013
// Copyright 2013 NoteIT
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

#import "LoginViewController.h"

#import "UIViewController+FKFormModel.h"
#import "SVProgressHUD.h"
#import "BWBackendObjectUpdateManager.h"
#import "BlocksKit.h"
#import "CoreData+MagicalRecord.h"
#import "NimbusCore.h"

#import "OAuth2Client.h"
#import "User.h"
#import "AppDelegate.h"
#import "List.h"
#import "Note.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface LoginViewController ()

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LoginViewController


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createAndLoadForm];
    
    self.title = @"Account";
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NIIsSupportedOrientation(interfaceOrientation);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark FormMapping


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setupFormMapping {
    self.formModel = [FKFormModel formTableModelForTableView:self.tableView];
    
    __weak LoginViewController *weakRef = self;
    [FKFormMapping mappingForClass:[User class] block:^(FKFormMapping *mapping) {
        [mapping sectionWithTitle:@"" identifier:@"credentails"];
        [mapping mapAttribute:@"email" title:@"Email" type:FKFormAttributeMappingTypeText keyboardType:UIKeyboardTypeEmailAddress];
        [mapping mapAttribute:@"password" title:@"Password" type:FKFormAttributeMappingTypePassword];
        
        if ([User isLoggedIn]) {
            [mapping buttonSave:@"Logout" handler:^{
                [weakRef didPressLogout];
            }];
        } else {
            [mapping buttonSave:@"Login" handler:^{
                [weakRef didPressLogin];
            }];
        }
        
        [mapping validationForAttribute:@"email" validBlock:^BOOL(NSString *value, id object) {
            return [weakRef isEmailValid];
        }];
        
        [mapping validationForAttribute:@"password" validBlock:^BOOL(NSString *value, id object) {
            return [weakRef isPasswordValid];
        }];
        
        [weakRef.formModel registerMapping:mapping];
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isEmailValid {
    return [[[User shared] email] length] > 5;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isPasswordValid {
    return [[[User shared] password] length] > 5;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createAndLoadForm {
    [self setupFormMapping];
    [self.formModel loadFieldsWithObject:[User shared]];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPressLogout {
    UIAlertView *alert = [UIAlertView alertViewWithTitle:@"Are you sure ?"];
    
    [alert addButtonWithTitle:@"No"];
    
    [alert addButtonWithTitle:@"Yes" handler:^{
        [User loggout];
        [List truncateAll];
        [Note truncateAll];
        [self createAndLoadForm];
    }];
    
    [alert show];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didPressLogin {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    User *user = [User shared];
    
    if (![self isEmailValid] || ![self isPasswordValid]) {
        return;
    }

    [[OAuth2Client sharedClient] authenticateUsingOAuthWithPath:@"/oauth/token"
                                                     username:[user.email lowercaseString]
                                                     password:user.password
                                                     clientID:CLIENT_ID
                                                       secret:CLIENT_SECRET
                                                      success:^(AFOAuthAccount *account) {
                                                          [SVProgressHUD showSuccessWithStatus:nil];
                                                          [[User shared] setAccessToken:account.credential.accessToken];
                                                          [self createAndLoadForm];
                                                          [[BWBackendObjectUpdateManager shared] update];
                                                          
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:nil];
        [self createAndLoadForm];
        
    }];
}


@end
