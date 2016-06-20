//
//  WeixinPayManager.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/20.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "WeixinPayManager.h"
#import "WeixinPaySignResponse.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import <NSString+MD5.h>

@implementation WeixinPayManager

+(void)payWithModule:(WeixinPayModule *)module controller:(UIViewController *)controller
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"body"]      = module.body;
    params[@"totalFee"]  = [NSString stringWithFormat:@"%0.f",module.totalFee.floatValue * 100];
    params[@"nonceStr"]  = [NSString ret32bitString];
    params[@"tradeType"] = @"APP";
    params[@"timestamp"] = [self timestamp];
    params[@"caseid"]    = module.caseId;
    params[@"spbillCreateIp"] = @"192.168.0.1";
    params[@"username"] = module.username;
    params[@"phoneNum"] = module.phoneNum;
    params[@"address"] = module.address;
    
    [controller.view showLoadingHudWithText:@"正在生成订单.."];
    [HttpManager requestWithAPI:@"user/doWeinXinRequest" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {

        [controller.view hideAllHud];
        
        WeixinPaySignResponse *response = [[WeixinPaySignResponse alloc]initWithString:request.responseString error:nil];
        if (response && response && response.result.resultCode.intValue == 0) {
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = WeixinAppId;
            req.partnerId           = WeixinPartnerId;
            req.prepayId            = response.prepayid;
            req.nonceStr            = params[@"nonceStr"];
            req.timeStamp           = [params[@"timestamp"]intValue];
            req.package             = @"Sign=WXPay";
            req.sign                = response.message;
            
            BOOL payResult = [WXApi sendReq:req];
            if (!payResult) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"订单生成失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    
    } failed:^(ASIFormDataRequest *request) {
        [controller.view showHudAndAutoDismiss:NetworkErrorPrompt];
    }];
}

+(NSString *)timestamp
{
    time_t now;
    time(&now);
    return [NSString stringWithFormat:@"%ld", now];
}

@end
