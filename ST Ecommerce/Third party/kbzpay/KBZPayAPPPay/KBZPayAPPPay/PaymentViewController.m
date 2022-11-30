//
//  PaymentViewController.m
//  PWASdkDemo
//
//  Created by mac2 on 2019/6/11.
//  Copyright © 2019年 mac2. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()<UIAlertViewDelegate>


@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)startPayWithOrderInfo:(NSString *)orderInfo signType:(NSString *)signType sign:(NSString *)sign appScheme:(NSString *)appScheme{
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    
    NSDictionary *userInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [userInfo objectForKey:@"CFBundleShortVersionString"];
    NSString *appName = [userInfo objectForKey:@"CFBundleDisplayName"];
    NSString *phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSString *phoneModel =  [[UIDevice currentDevice] model];
    
    NSString *finalURL = [[NSString stringWithFormat:@"kbzpay://?%@&sign_type=%@&sign=%@&tradeType=%@&bundleId=%@&appVersion=%@&appName=%@&phoneVersion=%@&phoneModel=%@&backUrlSchemes=%@",orderInfo,signType,sign,@"APP",bundleId,appVersion,appName,phoneVersion,phoneModel,appScheme] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:finalURL];
    if(![[UIApplication sharedApplication] canOpenURL:url]) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"" message:@"please install kbzpay app first" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
            // 跳转到App Store
            NSString *str = @"itms-apps://itunes.apple.com/cn/app/id1398852297?mt=8"; //更换id即可
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
        }];
        [alertView addAction:defaultAction];
        
        UIWindow *window = [UIApplication  sharedApplication].windows[0];
        UIViewController *topRootViewController = window.rootViewController;
        // 循环
        while (topRootViewController.presentedViewController)
        {
            
            topRootViewController = topRootViewController.presentedViewController;
        }
        [topRootViewController presentViewController:alertView animated:YES completion:nil];
    }else {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
