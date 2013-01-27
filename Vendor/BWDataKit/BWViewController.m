//
// Created by Bruno Wernimont on 2013
// Copyright 2012 BWDataKit
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
// Inspired by the great https://github.com/soffes/ssdatakit
//

#import "BWViewController.h"

#import "KSReachability.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BWViewController ()

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BWViewController

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        [self initializeViewController];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initializeViewController];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)loadView {
    [super loadView];
    
    self.view.autoresizesSubviews = YES;
    self.currentViewBounds = self.view.bounds;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shouldResiszeView = NO;
    
    [self startObservingNotifications];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload {
    [super viewDidUnload];
    
    [self stopObservingNotifications];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self canFetchResource] && self.shouldFetchResourceOnViewWillAppear) {
        [self fetchResource];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kDefaultNetworkReachabilityChangedNotification
                                               object:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kDefaultNetworkReachabilityChangedNotification
                                                  object:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Network

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reachabilityChanged:(NSNotification *)notification {
    KSReachability *reach = [notification object];
    
    if([reach reachable] && [self canFetchResource] && [self reloadResourceIfReachable]) {
        [self fetchResource];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)canFetchResource {
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)reloadResourceIfReachable {
    return NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)fetchResource {
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Notifications

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)startObservingNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameWillChange:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardFrameDidChange:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)stopObservingNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardFrameWillChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    self.keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    BOOL isPortrait = UIDeviceOrientationIsPortrait(self.interfaceOrientation);
    CGFloat keyboardHeight = (isPortrait ? self.keyboardRect.size.height : self.keyboardRect.size.width);
    
    CGRect currentViewBounds = self.currentViewBounds;
    currentViewBounds.size.height = CGRectGetHeight(self.view.bounds) - keyboardHeight;
    currentViewBounds.size.width = self.view.bounds.size.width;
    self.currentViewBounds = currentViewBounds;
    self.keyboardHidden = (keyboardHeight == 0);
    
    [self keyboardFrameWillChange];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardFrameDidChange:(NSNotification *)notification {
    [self keyboardFrameDidChange];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardFrameWillHide:(NSNotification *)notification {
    self.keyboardRect = CGRectZero;
    self.currentViewBounds = self.view.bounds;
    
    [self keyboardFrameWillChange];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardFrameWillChange {
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)keyboardFrameDidChange {
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateViewData {
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)hasContent {
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showLoadingView:(BOOL)show animated:(BOOL)aniamted {
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showNoContentView:(BOOL)show animated:(BOOL)animated {
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)initializeViewController {
    self.shouldFetchResourceOnViewWillAppear = YES;
}

@end
