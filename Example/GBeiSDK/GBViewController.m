//
//  GBViewController.m
//  GBeiSDK
//
//  Created by gbeicom on 06/17/2019.
//  Copyright (c) 2019 gbeicom. All rights reserved.
//

#import "GBViewController.h"
#import <GBeiSDK/GBeiSDK.h>

@interface GBViewController ()

@end

@implementation GBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 3;
    btn.layer.borderColor = [[UIColor blackColor] CGColor];
    btn.layer.borderWidth = 0.5;
    [btn setTitle:@"授权登录" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 120, 48);
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(gbeiClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


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

@end
