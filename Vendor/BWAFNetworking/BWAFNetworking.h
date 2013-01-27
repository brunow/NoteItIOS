//
//  BWAFNetworking.h
//  Notepad
//
//  Created by Bruno Wernimont on 19/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

typedef void(^BWAFNetworkingAllObjectsSuccessBlock)(NSArray *objects);

typedef void(^BWAFNetworkingObjectSuccessBlock)(id object);

typedef void(^BWAFNetworkingSuccessDeleteObjectBlock)(id object);

@interface BWAFNetworking : AFHTTPClient

@property (nonatomic, copy) BWAFNetworkingSuccessDeleteObjectBlock successDeleteBlock;

+ (id)sharedClient;

- (NSURL *)baseURL;

- (NSString *)path;

- (NSDictionary *)params;

- (void)allObjects:(Class)objectClass
            params:(NSDictionary *)params
           success:(BWAFNetworkingAllObjectsSuccessBlock)success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)allObjects:(Class)objectClass
        fromObject:(id)object
            params:(NSDictionary *)params
           success:(BWAFNetworkingAllObjectsSuccessBlock)success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)allObjects:(Class)objectClass
           success:(BWAFNetworkingAllObjectsSuccessBlock)success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)allObjects:(Class)objectClass
        fromObject:(id)object
           success:(BWAFNetworkingAllObjectsSuccessBlock)success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)postObject:(id)object
           success:(BWAFNetworkingObjectSuccessBlock)success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)deleteObject:(id)object
             success:(BWAFNetworkingObjectSuccessBlock)success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)getObject:(id)object
          success:(BWAFNetworkingObjectSuccessBlock)success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)putObject:(id)object
          success:(BWAFNetworkingObjectSuccessBlock)success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)setSuccessDeleteBlock:(BWAFNetworkingSuccessDeleteObjectBlock)successDeleteBlock;

@end
