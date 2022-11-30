//
//  APPConfig.h
//  KBZPayAPPPayDemo
//
//  Created by mac2 on 2019/7/5.
//  Copyright © 2019年 mac2. All rights reserved.
//

#ifndef APPConfig_h
#define APPConfig_h

//RBG转color
#define ColorWithRGB(r,g,b,alp) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:alp]
//十六进制转color
#define HexColor(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

#define UATBaseUrl               @"http://api.kbzpay.com/payment/gateway/uat/"
#define ProdBaseUrl              @"https://api.kbzpay.com/payment/gateway/"
#define CreateMethodUrl          @"kbz.payment.precreate"
#define CheckOrderMethodUrl      @"kbz.payment.queryorder"

//callback key
#define APPCallBackKey           @"APPCallBack"

#endif /* APPConfig_h */
