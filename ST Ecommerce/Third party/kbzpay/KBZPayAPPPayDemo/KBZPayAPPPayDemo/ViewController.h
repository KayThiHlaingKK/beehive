//
//  ViewController.h
//  KBZPayAPPPayDemo
//
//  Created by mac2 on 2019/7/5.
//  Copyright © 2019年 mac2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *merchantCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *appIdTF;

@property (weak, nonatomic) IBOutlet UITextField *prepayIdTF;
@property (weak, nonatomic) IBOutlet UITextField *callBackInfoTF;

@property (weak, nonatomic) IBOutlet UITextField *signKeyTF;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UITextField *NotifyUrlTF;
@property (weak, nonatomic) IBOutlet UITextField *MerchantOrderIdTF;

@property (weak, nonatomic) IBOutlet UIButton *UATButton;
@property (weak, nonatomic) IBOutlet UIButton *prodButton;
@property (weak, nonatomic) IBOutlet UITextField *nonceStrTF;

@end

