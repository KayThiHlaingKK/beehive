//
//  ViewController.m
//  KBZPayAPPPayDemo
//
//  Created by mac2 on 2019/7/5.
//  Copyright © 2019年 mac2. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPSessionManager.h"
#import "APPConfig.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import "UIView+Toast.h"
#import <KBZPayAPPPay/PaymentViewController.h>

#define nonce_str @"5K8264ILTKCH16CQ2502SI8ZNMTM67VS"
@interface ViewController ()

@property (nonatomic, strong) NSString *baseURL;
@property (assign) NSTimeInterval nowTimestamp;
@property (nonatomic, strong) NSDictionary *orderInfo;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"APP Pay";
    
    self.UATButton.selected = YES;
    self.prodButton.selected = NO;
    
    [self.UATButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.UATButton setTitleColor:HexColor(0xD43B32) forState:UIControlStateSelected];
    
    [self.prodButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.prodButton setTitleColor:HexColor(0xD43B32) forState:UIControlStateSelected];
    
    self.baseURL = UATBaseUrl;
    _nowTimestamp = [[NSDate date] timeIntervalSince1970];
    
    //监听支付回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkOrderStatusFromService:) name:APPCallBackKey object:nil];
    
}
#pragma mark - app call back -
- (void)checkOrderStatusFromService:(NSNotification *)noti {
    NSDictionary *infoDic = [noti object];
    NSString *extraResult = infoDic[@"EXTRA_RESULT"];
    NSString *extraOrderId = infoDic[@"EXTRA_ORDER_ID"];
    
    //0:success 3: cancel  目前只有两种状态返回
    if([extraResult isEqualToString:@"0"]) {
        [self checkOrderStatusWithOrderId:extraOrderId];
    }else if([extraResult isEqualToString:@"3"]) {
        [self.view makeToast:@"order cancel" duration:1.0 position:CSToastPositionBottom];
        return;
    }else {
        [self.view makeToast:@"order failed" duration:1.0 position:CSToastPositionBottom];
        return;
    }
}
- (IBAction)UATClicked:(UIButton *)sender {
    self.UATButton.selected = YES;
    self.prodButton.selected = NO;
    self.baseURL = UATBaseUrl;
}
- (IBAction)prodClicked:(UIButton *)sender {
    self.UATButton.selected = NO;
    self.prodButton.selected = YES;
    self.baseURL = ProdBaseUrl;
}

- (IBAction)createOrderClicked:(UIButton *)sender {
    
    if(self.merchantCodeTF.text.length == 0) {
        [self.view makeToast:@"please enter merchant code" duration:1.0 position:CSToastPositionBottom];
        return;
    }
    if(self.appIdTF.text.length == 0) {
        [self.view makeToast:@"please enter app id" duration:1.0 position:CSToastPositionBottom];
        return;
    }
    if(self.signKeyTF.text.length == 0) {
        [self.view makeToast:@"please enter sign key" duration:1.0 position:CSToastPositionBottom];
        return;
    }
    if(self.amountTF.text.length == 0) {
        [self.view makeToast:@"please enter amount" duration:1.0 position:CSToastPositionBottom];
        return;
    }
    if(self.MerchantOrderIdTF.text.length == 0) {
        [self.view makeToast:@"please enter merchant order id" duration:1.0 position:CSToastPositionBottom];
        return;
    }
    [self commonCreateOrder];
}

- (IBAction)startPayClicked:(UIButton *)sender {
    if(self.prepayIdTF.text.length == 0) {
        [self.view makeToast:@"Prepay id missing" duration:1.0 position:CSToastPositionBottom];
        return;
    }
    //这个urlScheme 必传,支付成功需要通过这个返回原有APP
    NSString *urlScheme = @"KBZPayAPPPayDemo";
    NSString *orderString = [NSString stringWithFormat:@"appid=%@&merch_code=%@&nonce_str=%@&prepay_id=%@&timestamp=%@",self.appIdTF.text,self.merchantCodeTF.text,self.nonceStrTF.text,self.prepayIdTF.text,@"987654321"];
    
    NSString *signStr = [NSString stringWithFormat:@"%@&key=%@",orderString,self.signKeyTF.text];
    NSString *sign = [self SHA256WithSignString:signStr];
    PaymentViewController *vc = [PaymentViewController new];
    [vc startPayWithOrderInfo:orderString signType:@"SHA256" sign:sign appScheme:urlScheme];
}

#pragma mark - 统一下单 -
- (void)commonCreateOrder {
    
    NSString *signString = [NSString stringWithFormat:@"appid=%@&callback_info=%@&merch_code=%@&merch_order_id=%@&method=%@&nonce_str=%@&notify_url=%@&timeout_express=100m&timestamp=%@&title=%@&total_amount=%@&trade_type=%@&trans_currency=MMK&version=1.0",self.appIdTF.text,self.callBackInfoTF.text,self.merchantCodeTF.text,self.MerchantOrderIdTF.text,CreateMethodUrl,nonce_str,self.NotifyUrlTF.text,@"987654321",@"iPhoneX",self.amountTF.text,@"APP"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *orderInfo = [NSMutableDictionary dictionary];
    
    [params setValue:@"987654321" forKey:@"timestamp"];
    [params setValue:self.NotifyUrlTF.text forKey:@"notify_url"];
    [params setValue:nonce_str forKey:@"nonce_str"];
    [params setValue:CreateMethodUrl forKey:@"method"];
    [params setValue:@"SHA256" forKey:@"sign_type"];
    [params setValue:@"1.0" forKey:@"version"];
    [params setValue:[self generateSignWithSignString:signString] forKey:@"sign"];
    
    [orderInfo setValue:self.MerchantOrderIdTF.text forKey:@"merch_order_id"];
    [orderInfo setValue:self.merchantCodeTF.text forKey:@"merch_code"];
    [orderInfo setValue:self.appIdTF.text forKey:@"appid"];
    [orderInfo setValue:@"APP" forKey:@"trade_type"];
    [orderInfo setValue:@"iPhoneX" forKey:@"title"];
    [orderInfo setValue:self.amountTF.text forKey:@"total_amount"];
    [orderInfo setValue:@"MMK" forKey:@"trans_currency"];
    [orderInfo setValue:@"100m" forKey:@"timeout_express"];
    [orderInfo setValue:self.callBackInfoTF.text forKey:@"callback_info"];
    
    [params setObject:orderInfo forKey:@"biz_content"];
    
    NSMutableDictionary *request = [NSMutableDictionary new];
    [request setValue:params forKey:@"Request"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",nil]];
    
    NSString *url = [self.baseURL stringByAppendingString:@"precreate"];
    NSLog(@"current url %@",url);
    [manager POST:url parameters:request success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response data %@",responseObject);
        NSDictionary *responseData = (NSDictionary *)responseObject;
        NSDictionary *response = responseData[@"Response"];
        NSString *code = response[@"code"];
        NSString *responseMsg = response[@"msg"];
        if([code isEqualToString:@"0"]) {
            self.orderInfo = response;
            self.prepayIdTF.text = response[@"prepay_id"];
        }else {
            [self.view makeToast:responseMsg duration:1.0 position:CSToastPositionBottom];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
//generate sign
- (NSString *)generateSignWithSignString:(NSString *)signString {
    NSString *finalSignString = [signString stringByAppendingString:[NSString stringWithFormat:@"&key=%@",self.signKeyTF.text]];
    NSString *sign = [self SHA256WithSignString:finalSignString];
    return sign;
}
#pragma mark - Encrypt -
- (NSString*)SHA256WithSignString:(NSString*)signString
{
    const char* str = [signString UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    ret = (NSMutableString *)[ret uppercaseString];
    return ret;
}
- (NSString *)JsonFromObj:(id)obj{
    NSError* error = nil;
    NSData* jsonData = nil;
    if(obj == nil) {
        return @"";
    }
    
    jsonData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&error];
    
    if (error || !jsonData) {
        NSLog(@"Json error:%@",[error description]);
        return nil;
    }
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}
#pragma mark - check order -
- (void)checkOrderStatusWithOrderId:(NSString *)orderId {
    
    NSString *signString = [NSString stringWithFormat:@"appid=%@&merch_code=%@&merch_order_id=%@&method=%@&nonce_str=%@&timestamp=%@&version=1.0",self.appIdTF.text ,self.merchantCodeTF.text,orderId,CheckOrderMethodUrl,nonce_str,@"987654321"];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"987654321" forKey:@"timestamp"];
    [params setValue:nonce_str forKey:@"nonce_str"];
    [params setValue:CheckOrderMethodUrl forKey:@"method"];
    [params setValue:@"SHA256" forKey:@"sign_type"];
    [params setValue:[self generateSignWithSignString:signString] forKey:@"sign"];
    [params setValue:@"1.0" forKey:@"version"];
    
    NSMutableDictionary *biz_content = [NSMutableDictionary new];
    [biz_content setValue:self.merchantCodeTF.text forKey:@"merch_code"];
    [biz_content setValue:orderId forKey:@"merch_order_id"];
    [biz_content setValue:self.appIdTF.text forKey:@"appid"];
    [params setObject:biz_content forKey:@"biz_content"];
    
    NSMutableDictionary *request = [NSMutableDictionary new];
    [request setValue:params forKey:@"Request"];
    
    NSLog(@"%@",request);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",@"application/atom+xml",@"application/xml",@"text/xml",nil]];
    
    NSString *url = [self.baseURL stringByAppendingString:@"queryorder"];
    
    [manager POST:url parameters:request success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response data %@",responseObject);
        NSDictionary *responseData = responseObject[@"Response"];
        NSString *result = responseData[@"result"];
        if([result isEqualToString:@"SUCCESS"]) {
            NSString *trade_status = responseData[@"trade_status"];
            /*order status
             PAY_SUCCESS,PAY_FAILED,WAIT_PAY/PAYING
            */
            if([trade_status isEqualToString:@"PAY_SUCCESS"]) {
                //do something success
                [self.view makeToast:@"order pay success" duration:1.0 position:CSToastPositionBottom];
            }else if ([trade_status isEqualToString:@"PAY_FAILED"]) {
                [self.view makeToast:@"order pay fail" duration:1.0 position:CSToastPositionBottom];
            }else if ([trade_status isEqualToString:@"WAIT_PAY"] || [trade_status isEqualToString:@"PAYING"]) {
                [self.view makeToast:@"order wait pay" duration:1.0 position:CSToastPositionBottom];
            }else {
                [self.view makeToast:responseData[@"msg"] duration:1.0 position:CSToastPositionBottom];
            }
        }else {
            [self.view makeToast:@"check order fail" duration:1.0 position:CSToastPositionBottom];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}
@end
