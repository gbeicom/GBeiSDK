//
//  Author.m
//  JD_User
//
//  Created by IFY on 2019/6/4.
//  Copyright © 2019 mac. All rights reserved.
//

#import "GBOAuth.h"
#import <UIKit/UIKit.h>

@interface GBAccount : NSObject
@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy) NSString *appKey;
@end
@implementation GBAccount

@end


@interface GBOAuth()
@property (nonatomic, strong) GBAccount *account;
@property (nonatomic, copy) OAuthCompletionHandler oauthCompletionHandler;

@end

@implementation GBOAuth

static GBOAuth *auth = nil;
+ (GBOAuth *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        auth = [[self alloc] init];
    });
    return auth;
}


+ (BOOL)isInstalled {
    return [GBOAuth openURL:@"gbei://"];
}

- (void)setupAccountWithappID:(NSString *)appID appKey:(NSString *)appKey  {
    self.account = [[GBAccount alloc] init];
    self.account.appID = appID;
    self.account.appKey = appKey;
}

+ (void)oauth:(OAuthCompletionHandler)completionHandler {
    if ([GBOAuth isInstalled] && [[GBOAuth shared] account] != nil) {
        [GBOAuth shared].oauthCompletionHandler = completionHandler;
        NSString *urlStr = [NSString stringWithFormat:@"gbei://app/auth?appId=%@&state=auth", [GBOAuth shared].account.appID];
        [self openURL:urlStr options:nil completionHandler:^(BOOL success) {
            if (!success) {
                completionHandler(nil, [NSError errorWithDomain:@"OAuth Error, cannot open url gbei://" code:-1 userInfo:nil]);
            }
        }];
    }
}


+ (BOOL)handleOpenURL:(NSURL *)url {
    NSString *urlScheme = url.scheme;
    if (urlScheme == nil || [urlScheme length] == 0) {
        return NO;
    }
    if ([urlScheme hasPrefix:@"gb"]) {
        NSString * urlString = url.absoluteString;
        // OAuth
        if ([urlString containsString:@"state=auth"]) {
            NSDictionary *queryDictionary = [self parameterWithURL:url];
            NSString *code = queryDictionary[@"code"];
            if (code == nil || [code length] == 0) {
                [GBOAuth shared].oauthCompletionHandler = nil;
                return NO;
            }
            NSLog(@"code %@", code);
            if ([GBOAuth shared].oauthCompletionHandler != nil) {
                [GBOAuth shared].oauthCompletionHandler(code, nil);
            }
            return YES;
        }
    }
    return NO;
}

/**
 获取url的所有参数
 @param url 需要提取参数的url
 @return NSDictionary
 */
+(NSDictionary *) parameterWithURL:(NSURL *) url {
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    return parm;
}


+ (void)openURL:(NSString *)urlStr options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey,id> *)options completionHandler:(void (^)(BOOL success))completion {
    if (urlStr == nil || [urlStr length] == 0) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
#ifdef __IPHONE_11_0
    if (@available(iOS 10.0, *))
#else
        if (IQ_IS_IOS10_OR_GREATER)
#endif
        {
            [[UIApplication sharedApplication] openURL:url options:options completionHandler:^(BOOL success) {
                if (completion) {
                    completion(success);
                }
            }];
        } else {
            if (completion) {
                completion([[UIApplication sharedApplication] openURL:url]);
            }
        }
}


+ (BOOL)openURL:(NSString *)urlStr {
    if (urlStr == nil || [urlStr length] == 0) {
        return NO;
    }
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]];
}


- (BOOL)canOpenURL:(NSString *)urlStr {
    if (urlStr == nil || [urlStr length] == 0) {
        return NO;
    } else {
        return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]];
    }
}

+ (NSString *)versionString {
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"GBOAuth")] ;
    NSString* filePath = [bundle pathForResource:@"Info" ofType:@"plist"];
//    NSString* filePath = [NSString stringWithFormat:@"%@/%@",[bundle bundlePath], @"Info.plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSString *version = [dic objectForKey:@"CFBundleShortVersionString"];
    return version;
}

@end
