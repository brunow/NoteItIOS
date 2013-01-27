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

#import "SettingsViewController.h"

#import "UIViewController+FKFormModel.h"
#import "UINavigationController+BarButtonItem.h"
#import "NimbusCore.h"

#import "LoginViewController.h"
#import "Settings.h"
#import "User.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SettingsViewController ()

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SettingsViewController


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
    
    self.navigationItem.leftBarButtonItem = [self.navigationController doneBarButtonItem];
    
    [self setuptFormMapping];
    [self.formModel loadFieldsWithObject:[Settings shared]];
    
    self.title = @"Settings";
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[Settings shared] save];
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
- (void)setuptFormMapping {
    self.formModel = [FKFormModel formTableModelForTableView:self.tableView];
    
    __weak SettingsViewController *weakRef = self;
    [FKFormMapping mappingForClass:[Settings class] block:^(FKFormMapping *mapping) {
        [mapping sectionWithTitle:@"" identifier:@"credentials"];
        [mapping mapAttribute:@"preferMarkdownSyntax" title:@"Prefer mardown syntax" type:FKFormAttributeMappingTypeBoolean];
        
        [mapping mapAttribute:@"showTextToolbarAccesory" title:@"Show input toolbar" type:FKFormAttributeMappingTypeBoolean];
        
        [mapping sectionWithTitle:@"Acount" identifier:@"acount"];
        
        [mapping button:@"Acount" identifier:@"acount_button" handler:^(id object) {
            [weakRef.navigationController pushViewControllerWithBlock:^UIViewController *{
                return [[LoginViewController alloc] init];
            } animated:YES];
            
        } accesoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        [weakRef.formModel registerMapping:mapping];
    }];
}


@end
