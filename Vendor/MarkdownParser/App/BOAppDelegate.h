//
//  BOAppDelegate.h
//  MarkdownParser
//
//  Created by Daniel Eggert on 10/5/12.
//  Copyright (c) 2012 Bödewadt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BOViewController;

@interface BOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BOViewController *viewController;

@end
