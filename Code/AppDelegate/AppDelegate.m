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

#import "AppDelegate.h"

#import "BWBackendObjectUpdateManager.h"
#import "BWObjectMapper.h"
#import "BWObjectSerializer.h"
#import "BWObjectRouter.h"
#import "BaseKitCoreData.h"
#import "CoreData+MagicalRecord.h"
#import "NSManagedObject+FindOrCreate.h"
#import "KSReachability.h"

#import "Defines.h"
#import "ListsTableViewController.h"
#import "NoteViewController.h"
#import "LoginViewController.h"
#import "Settings.h"
#import "ListsNotesSplitViewController.h"
#import "User.h"
#import "Note.h"
#import "List.h"
#import "HttpClient.h"
#import "SplashViewController.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AppDelegate ()

- (void)initializeBackendUpdateManager;

- (void)initializeSettings;

- (void)initializeReachability;

- (void)initializeObjectSerializer;

- (void)initializeRoutes;

- (void)initializeObjectMapping;

- (void)syncSettings;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AppDelegate

@synthesize window = _window;

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
//    [List truncateAll];
//    [Note truncateAll];
    
    [self initializeSettings];
    [self initializeObjectSerializer];
    [self initializeRoutes];
    [self initializeObjectMapping];
    [self initializeBackendUpdateManager];
    [self initializeReachability];
    [self initializeAppearance];
    [self syncSettings];
    
    if (BKIsPad()) {
        ListsNotesSplitViewController *sc = [[ListsNotesSplitViewController alloc] init];
        self.window.rootViewController = sc;
    } else {
        UIViewController *vc = [[ListsTableViewController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nc;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[BWBackendObjectUpdateManager shared] update];
    
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[BWBackendObjectUpdateManager shared] update];
    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSManagedObjectContext MR_defaultContext] saveNestedContexts];
    [MagicalRecord cleanUp];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)syncSettings {
    
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)initializeReachability {
    self.reachability = [KSReachability reachabilityToHost:API_BASE_URL];
    self.reachability.notificationName = kDefaultNetworkReachabilityChangedNotification;
    
    self.reachability.onReachabilityChanged = ^(KSReachability *reachability) {
        if ([reachability reachable])
            [[BWBackendObjectUpdateManager shared] update];
    };
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)initializeSettings {
    Settings *settings = [Settings shared];
    
    if (nil == settings.preferMarkdownSyntax)
        settings.preferMarkdownSyntax = BK_BOOLEAN(YES);
    
    if (nil == settings.showTextToolbarAccesory)
        settings.showTextToolbarAccesory = BK_BOOLEAN(YES);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)initializeBackendUpdateManager {
    BWBackendObjectUpdateManager *updataManager = [BWBackendObjectUpdateManager shared];
    
    [updataManager objectChangeWithBlock:^(NSManagedObject *object, BWBackendObjectUpdateChangeType type, BWBackendObjectSuccessChangeBlock successCallbackBlock, BWBackendObjectFailureChangeBlock failureCallbackBlock) {
        
        if ([User isLoggedIn]) {
            HttpClient *client = [HttpClient sharedClient];
            
            [client postObject:object success:^(id object) {
                successCallbackBlock(object);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failureCallbackBlock(object);
            }];
        } else {
            failureCallbackBlock(object);
        }
    }];
    
    [updataManager watchObjectsUpdatesForEntity:@"List"];
    [updataManager watchObjectsUpdatesForEntity:@"Note"];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)initializeObjectSerializer {
    [BWObjectSerializerMapping mappingForObject:[List class] block:^(BWObjectSerializerMapping *serializer) {
        [serializer mapKeyPath:@"title" toAttribute:@"title"];
        [serializer mapKeyPath:@"position" toAttribute:@"position"];
        [serializer mapKeyPath:@"createdAt" toAttribute:@"created_at"];
        [serializer mapKeyPath:@"updatedAt" toAttribute:@"updated_at"];
        [serializer mapKeyPath:@"deletedAt" toAttribute:@"deleted_at"];
        [serializer mapKeyPath:@"objectChangedAt" toAttribute:@"object_changed_at"];
        
        [serializer mapKeyPath:@"listID" toAttribute:@"id"];
        
        [[BWObjectSerializer shared] registerSerializer:serializer withRootKeyPath:@"list"];
    }];
    
    [BWObjectSerializerMapping mappingForObject:[Note class] block:^(BWObjectSerializerMapping *serializer) {
        [serializer mapKeyPath:@"title" toAttribute:@"title"];
        [serializer mapKeyPath:@"content" toAttribute:@"content"];
        [serializer mapKeyPath:@"position" toAttribute:@"position"];
        [serializer mapKeyPath:@"createdAt" toAttribute:@"created_at"];
        [serializer mapKeyPath:@"updatedAt" toAttribute:@"updated_at"];
        [serializer mapKeyPath:@"deletedAt" toAttribute:@"deleted_at"];
        [serializer mapKeyPath:@"objectChangedAt" toAttribute:@"object_changed_at"];
        [serializer mapKeyPath:@"noteID" toAttribute:@"id"];
        
        [[BWObjectSerializer shared] registerSerializer:serializer withRootKeyPath:@"note"];
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)initializeObjectMapping {
    [BWObjectMapping mappingForObject:[List class] block:^(BWObjectMapping *mapping) {
        [mapping mapPrimaryKeyAttribute:@"id" toAttribute:@"listID"];
        [mapping mapKeyPath:@"title" toAttribute:@"title"];
        [mapping mapKeyPath:@"created_at" toAttribute:@"createdAt"];
        [mapping mapKeyPath:@"updated_at" toAttribute:@"updatedAt"];
        [mapping mapKeyPath:@"deleted_at" toAttribute:@"deletedAt"];
        [mapping mapKeyPath:@"position" toAttribute:@"position"];

        [[BWObjectMapper shared] registerMapping:mapping withRootKeyPath:nil];
    }];
    
    [BWObjectMapping mappingForObject:[Note class] block:^(BWObjectMapping *mapping) {
        [mapping mapPrimaryKeyAttribute:@"id" toAttribute:@"noteID"];
        [mapping mapKeyPath:@"title" toAttribute:@"title"];
        [mapping mapKeyPath:@"content" toAttribute:@"content"];
        [mapping mapKeyPath:@"created_at" toAttribute:@"createdAt"];
        [mapping mapKeyPath:@"updated_at" toAttribute:@"updatedAt"];
        [mapping mapKeyPath:@"deleted_at" toAttribute:@"deletedAt"];
        [mapping mapKeyPath:@"position" toAttribute:@"position"];
        
        [mapping mapKeyPath:@"list_id" toAttribute:@"list" valueBlock:^id(id value, id object) {
            return [List MR_findOrCreateByAttribute:@"listID" value:value];
        }];
        
        [[BWObjectMapper shared] registerMapping:mapping withRootKeyPath:nil];
    }];
    
    [[BWObjectMapper shared] objectWithBlock:^id(Class objectClass, NSString *primaryKey, id primaryKeyValue, id JSON) {
        NSManagedObject *object = [objectClass MR_findOrCreateByAttribute:primaryKey value:primaryKeyValue];
        
        if ([object objectChangeType] != BWBackendObjectUpdateChangeNone) {
            object = nil;
        }
        
        return object;
    }];
    
    [[BWObjectMapper shared] didMapObjectWithBlock:^void(NSManagedObject *object) {
        [object.managedObjectContext saveNestedContexts];
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)initializeRoutes {
    [[BWObjectRouter shared] routeObjectClass:[List class]
                               toResourcePath:@"/lists/:listID"
                                    forMethod:BWObjectRouterMethodAllExceptPOST];
    
    [[BWObjectRouter shared] routeObjectClass:[List class]
                               toResourcePath:@"/lists/"
                                    forMethod:BWObjectRouterMethodINDEX];
    
    [[BWObjectRouter shared] routeObjectClass:[List class]
                               toResourcePath:@"/lists"
                                    forMethod:BWObjectRouterMethodPOST];
    
    
    
    [[BWObjectRouter shared] routeObjectClass:[Note class]
                               toResourcePath:@"/lists/:listID/notes"
                                    forMethod:BWObjectRouterMethodINDEX];
    
    [[BWObjectRouter shared] routeObjectClass:[Note class]
                               toResourcePath:@"/lists/:list.listID/notes/:noteID"
                                    forMethod:BWObjectRouterMethodAllExceptPOST];
    
    [[BWObjectRouter shared] routeObjectClass:[Note class]
                               toResourcePath:@"/lists/:list.listID/notes/"
                                    forMethod:BWObjectRouterMethodPOST];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)initializeAppearance {
    UIImage *backBtn = [[UIImage imageNamed:@"btn-back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 13, 14, 5)];
    UIImage *navBarBtn = [[UIImage imageNamed:@"btn-nav-bar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 6, 14, 6)];
    UIImage *toolBarBtn = [[UIImage imageNamed:@"toolbar-btn-light.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 6, 15, 6)];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav-bar.png"]
                                       forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backBtn
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackgroundImage:navBarBtn
                                                                                        forState:UIControlStateNormal
                                                                                      barMetrics:UIBarMetricsDefault];
     
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"bg-toolbar.png"]
                            forToolbarPosition:UIToolbarPositionAny
                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackgroundImage:toolBarBtn
                                            forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
        UITextAttributeTextColor : [UIColor whiteColor]
     }];
    
    [[UISwitch appearance] setOnTintColor:BK_RGB_COLOR(148, 207, 63)];
}


@end


