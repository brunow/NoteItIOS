//
// Created by Bruno Wernimont on 2012
// Copyright 2012 BWLongTextViewController
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

#import "BWLongTextViewController.h"

#define HAS_ARC (__has_feature(objc_arc))
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BWLongTextViewController ()

- (void)startObservingNotifications;

- (void)stopObservingNotifications;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BWLongTextViewController

@synthesize textView;
@synthesize text = _text;


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    self.text = nil;
#if !HAS_ARC
    [super dealloc];
#endif
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithText:(NSString *)text {
    self = [self init];
    if (self) {
        self.text = text;
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    self = [super init];
    if (self) {
        self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startObservingNotifications];
    
    self.view.backgroundColor = [UIColor whiteColor];

    CGRect frame = self.view.bounds;
    frame.origin.y = 3;
    self.textView.frame = frame;
//    self.textView = [[UITextView alloc] initWithFrame:frame];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textView.returnKeyType = UIReturnKeyGo;
    self.textView.text = self.text;
    [self.textView becomeFirstResponder];
    [self.view addSubview:self.textView];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload {
    [super viewDidUnload];
    
//    self.textView = nil;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (IS_IPAD || UIInterfaceOrientationPortraitUpsideDown != interfaceOrientation) {
        return YES;
    }
    return NO;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Notifications


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)startObservingNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveKeyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification 
                                               object:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)stopObservingNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didReceiveKeyboardWillShowNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    BOOL isPortrait = UIDeviceOrientationIsPortrait(self.interfaceOrientation);
    CGFloat keyboardHeight = (isPortrait ? keyboardRect.size.height : keyboardRect.size.width);
    
    CGRect frame = self.textView.frame;
    frame.size.height = self.view.frame.size.height - self.textView.frame.origin.y - keyboardHeight;
    
    self.textView.frame = frame;
}


@end
