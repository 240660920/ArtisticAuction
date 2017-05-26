//
//  LoginManager.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/8.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "LoginManager.h"
#import "LoginResponse.h"

@implementation LoginManager

+(void)login:(LoginType)loginType autoLogin:(BOOL)autoLogin params:(NSMutableDictionary *)params successBlock:(void(^)(void))successBlock failedBlock:(void(^)(NSString *errorMsg))failedBlock
{
    //手机号登录
    if (loginType == kLoginTypePhone) {
        if (autoLogin == YES) {
            params = [[NSMutableDictionary alloc]init];
            params[@"phoneNum"] = [UserInfo sharedInstance].phone;
            params[@"password"] = [UserInfo sharedInstance].password;
            params[@"type"] = @"0";
        }
        
        [HttpManager requestWithAPI:@"user/userLogin" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
            
            LoginResponse *response = [[LoginResponse alloc]initWithString:request.responseString error:nil];
            if (response && response.result.resultCode.intValue == 0) {
                
                [self setUserInfoWithLoginResponse:response username:params[@"phoneNum"] password:params[@"password"] loginType:loginType];
                
                [UserInfo sharedInstance].loginType = kLoginTypePhone;
                
                [[UserInfo sharedInstance]archive];
                
                successBlock();
            }
            else{
                if (!autoLogin) {
                    if (response.result.msg) {
                        failedBlock(response.result.msg);
                    }
                    else{
                        failedBlock(@"服务器异常");
                    }
                }
                else{
                    failedBlock(@"登录失败");
                }
            }
            
        } failed:^(ASIFormDataRequest *request) {
            failedBlock(NetworkErrorPrompt);
        }];
    }
    //微信登录
    else if (loginType == kLoginTypeWeixin){
        if (autoLogin) {
            params = [[NSMutableDictionary alloc]init];
            params[@"type"] = @"1";
            params[@"username"] = [UserInfo sharedInstance].weixinUniqueId;
        }
        
        [HttpManager requestWithAPI:@"user/userLogin" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
            
            LoginResponse *response = [[LoginResponse alloc]initWithString:request.responseString error:nil];
            if (response && response.result.resultCode.intValue == 0) {
                
                [self setUserInfoWithLoginResponse:response username:params[@"username"] password:@"" loginType:kLoginTypeWeixin];
                
                [UserInfo sharedInstance].loginType = kLoginTypeWeixin;
                
                [[UserInfo sharedInstance]archive];

                successBlock();
            }
            else{
                if (!autoLogin) {
                    failedBlock(response.result.msg);
                }
                else{
                    failedBlock(nil);
                }
            }
            
        } failed:^(ASIFormDataRequest *request) {
            failedBlock(NetworkErrorPrompt);
        }];
    }
    //游客登录
    else if (loginType == kLoginTypeTraveller){
        
        [UserInfo sharedInstance].loginType = kLoginTypeTraveller;

        [[UserInfo sharedInstance]archive];

        successBlock();
    }
}

+(void)setUserInfoWithLoginResponse:(LoginResponse *)response username:(NSString *)username password:(NSString *)password loginType:(LoginType )loginType
{
    [UserInfo sharedInstance].realName     = response.data.realname;
    [UserInfo sharedInstance].phone        = response.data.phone;
    [UserInfo sharedInstance].password     = response.data.password;
    [UserInfo sharedInstance].userId       = response.data.userid;
    [UserInfo sharedInstance].identifyCertifyState = response.data.realtype.intValue;
    [UserInfo sharedInstance].agencyName = response.data.occasionName;
    
    [[UserInfo sharedInstance]addContactInfo:response];
}

@end
