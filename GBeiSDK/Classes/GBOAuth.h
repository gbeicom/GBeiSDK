//
//  Author.h
//  JD_User
//
//  Created by IFY on 2019/6/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^OAuthCompletionHandler)(NSString * _Nullable code, NSError * _Nullable error);

@interface GBOAuth : NSObject
+ (GBOAuth *)shared;

+ (BOOL)isInstalled;


+ (void)oauth:(OAuthCompletionHandler)completionHandler;

- (void)setupAccountWithappID:(NSString *)appID appKey:(NSString *)appKey;

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (NSString *)versionString;

@end

NS_ASSUME_NONNULL_END
