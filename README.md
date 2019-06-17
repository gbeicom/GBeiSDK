# GBeiSDK使用指南

[![CI Status](https://img.shields.io/travis/gbeicom/GBeiSDK.svg?style=flat)](https://travis-ci.org/gbeicom/GBeiSDK)
[![Version](https://img.shields.io/cocoapods/v/GBeiSDK.svg?style=flat)](https://cocoapods.org/pods/GBeiSDK)
[![License](https://img.shields.io/cocoapods/l/GBeiSDK.svg?style=flat)](https://cocoapods.org/pods/GBeiSDK)
[![Platform](https://img.shields.io/cocoapods/p/GBeiSDK.svg?style=flat)](https://cocoapods.org/pods/GBeiSDK)

## 样例 

github 上有使用[demo](https://github.com/gbeicom/GBeiSDK.git)

## 安装方式

Pod

```ruby
pod 'GBeiSDK'
```



## 使用方式

1.添加白名单 gbei 

![D8861753-4EB1-4331-8BAC-FF2D445F0BA6](assets/D8861753-4EB1-4331-8BAC-FF2D445F0BA6.png)



2.添加 URL type 格式为 gb+appid

![F86240B0-9661-4784-9E57-7FCBDE84E6C5](assets/F86240B0-9661-4784-9E57-7FCBDE84E6C5.png)



3.注册 appid 和 appkey，处理回调

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[GBOAuth shared] setupAccountWithappID:GBAPPID appKey:GBAPPKEY];

    return YES;
}


-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
     if ([GBOAuth handleOpenURL:url] ) {
        return YES;
    }
    
    return YES;
}

```



4.发起授权请求

```
#pragma mark ---京贝尔登录
-(void)gbeiClick:(UIButton *)btton{
    [GBOAuth oauth:^(NSString * _Nonnull code, NSError * _Nonnull error) {
        // 获取code
        NSInteger errcode = error.code;
        if (errcode == -1) {
            NSLog(@"-----error-------\n%@", error.domain);
        } else {
            [self gbeiLogin:code];
        }
    }];
}


-(void)gbeiLogin:(NSString *) code {
    NSLog(@"返回code %@", code);
}

```





## Author

gbeicom, 1055004344@qq.com

## License

GBeiSDK is available under the MIT license. See the LICENSE file for more info.
