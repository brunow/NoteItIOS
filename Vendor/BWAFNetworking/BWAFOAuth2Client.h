//
//  BWAFOAuth2Client.h
//  Notepad
//
//  Created by Bruno Wernimont on 19/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFOAuth2Client.h"
#import "AFNetworking.h"

@interface BWAFOAuth2Client : AFOAuth2Client

+ (id)sharedClient;

- (NSURL *)baseURL;

- (void)authenticateUsingOAuthWithPath:(NSString *)path
                              username:(NSString *)username
                              password:(NSString *)password
                              clientID:(NSString *)clientID 
                                secret:(NSString *)secret 
                               success:(void (^)(AFOAuthAccount *account))success 
                               failure:(void (^)(NSError *error))failure;

@end
