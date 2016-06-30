//
//  AlipayManager.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/15.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AlipayManager.h"
#import "DataSigner.h"
#import "DataVerifier.h"
#import "AlipayResultModule.h"

AlipayManager *alipayManager;

@implementation AlipayManager

+(id)sharedInstance
{
    if (!alipayManager) {
        alipayManager = [[AlipayManager alloc]init];
    }
    return alipayManager;
}

-(void)payOrder:(AlipayOrder *)order completionBlock:(CompletionBlock)completionBlock controller:(UIViewController *)controller
{    
    NSString *appScheme = @"artisticauction";

    NSString *orderSpec = [order description];
    
    NSString *urlEncodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)orderSpec, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    
    [controller.view showLoadingHudWithText:@"正在生成订单.."];
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"username"] = order.username;
    params[@"phoneNum"] = order.phoneNum;
    params[@"address"] = order.address;
    params[@"message"] = urlEncodedString;
    params[@"notify_url"] = order.notifyURL;
    params[@"caseid"] = order.caseId;
    params[@"tradeNO"] = order.tradeNO;
    
    [HttpManager requestWithAPI:@"user/getRsaMessage" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {

        [controller.view hideAllHud];
        
        NSDictionary *rstDic = [request.responseString objectFromJSONString];
        if ([rstDic[@"result"][@"resultCode"]intValue] == 0 && rstDic[@"message"]) {
            NSString *signedString = rstDic[@"message"];
            
            NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                     orderSpec, signedString, @"RSA"];
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                
                AlipayResultModule *module = [[AlipayResultModule alloc]initWithDictionary:resultDic];
                if (module.resultCode == 9000) {
                    NSString *publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB";
                    id<DataVerifier>verifier = CreateRSADataVerifier(publicKey);
                    BOOL result = [verifier verifyString:module.orderInfo withSign:module.sign];

                    if (result == YES) {
                        completionBlock(resultDic);
                    }
                    else{
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        }
        else{
            [controller.view showHudAndAutoDismiss:@"订单生成失败"];
        }
        
    } failed:^(ASIFormDataRequest *request) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付签名失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
//    NSString *privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBANmGBcMF4SI/NDVWg0GJmfD9ndHJmOXanW0pswe2uAGeswf16utPBTXvPsJPQOrcc7OrlCEYhIeAc+cZO+BymRuNGpzL9ZjiJ3weYt9bSSx+xNhkdi2dRTrjZ/BjG7xsS7xX/7qZ/5lHaI0p8cHNhqYe844O7grVhO4S3KwzK3+NAgMBAAECgYEAi2HPi1nXGuS5BXx7+qC7XaqFWAn/yTk+KtbPex/f5FnWikFP2Jv30MmOw1+ZT2UXVoeZEWPueA0dN3X54iZMaCZyzzJUY+zIXZApGBZjCNCXOvyTw06FU/5Lj4YWY+d+ZMpp382ELEyPKfU3jsmQcYHRkBDpQ2dor0sdFgupIdkCQQD0n1Goi4aXIwp+cOBghZIkjNZdLfUIC5g/vmZz+OTcwNTlx49HEjC0EBPPcTzMVOTRJ9PL9tphVZxs4BCmOoG3AkEA46QKxMfmtf13wReIypX1y9y3FYSfOjsSI7IJstJceyGJhkvCxGaG8SGkeZ6ZBHdwdKh36Jz3Bj8/+IzVoTW42wJBAJZNvhLdiBkdQrlmCbfE2oLytlQShNgop6ejCbiAWb76DNYSxApbNumsZz+yyDSUhPOukQhl6NCdlbugARriIAkCQQDdkNEabydTg32H54wxAnzXC+D3hLomR1CEhcmCz9VL03yzxhGwb8pv8LrR1VhCTK6cHU14jy6wWee91/Ymjs95AkA6NOcQEXyrkQx4D5h4fH3FlT5vnBBZCSA8M36B8XE5NeYIDOfLAlAM0xubU7xt1IiQmORxydBCOl26yb2jM/th";
//    
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//
//            AlipayResultModule *module = [[AlipayResultModule alloc]initWithDictionary:resultDic];
//
//            NSString *publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB";
//            id<DataVerifier>verifier = CreateRSADataVerifier(publicKey);
//            BOOL result = [verifier verifyString:module.orderInfo withSign:module.sign];
//            if (result == YES) {
//                
//            }
//            else{
//                
//            }
//        }];
//    }
}

@end
