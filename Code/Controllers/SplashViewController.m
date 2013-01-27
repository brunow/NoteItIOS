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

#import "SplashViewController.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface SplashViewController ()

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation SplashViewController


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super initWithNibName:@"SplashViewController" bundle:nil];
    if (self) {
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self styleSplash];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload {
    [super viewDidUnload];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self styleSplash];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)styleSplash {
    NSString *backgroundImageName = nil;
    
    CGSize screenSize = [[[UIApplication sharedApplication] keyWindow] frame].size;
    
    CGFloat width = UIDeviceOrientationIsPortrait(self.interfaceOrientation) ? screenSize.width : screenSize.height;
    CGFloat height = (UIDeviceOrientationIsPortrait(self.interfaceOrientation) ? screenSize.height : screenSize.width);
    
    if (!BKIsPad()) {
        backgroundImageName = @"splash-background-portrait.png";
    } else if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
        backgroundImageName = @"splash-background-portrait-ipad.png";
    } else {
        backgroundImageName = @"splash-background-landscape-ipad.png";
    }
    
    if (BKIsPad()) {
        self.logoImageView.image = [UIImage imageNamed:@"big-logo-ipad.png"];
    } else {
        self.logoImageView.image = [UIImage imageNamed:@"big-logo.png"];
    }
    
    if (BKIsPad()) {
        CGRect frame = CGRectMake(0, height - 4, width, 4);
        self.bottomLineView.frame = frame;
    }
    
    [self.logoImageView sizeToFit];
    
    self.topLineView.backgroundColor = BK_RGB_COLOR(191, 236, 125);
    self.insideView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:backgroundImageName]];
    self.bottomLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hr-line.png"]];
    
    self.logoImageView.center = CGPointMake(width / 2, (height - 60) / 2);
}


@end
