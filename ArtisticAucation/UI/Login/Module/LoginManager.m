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
            params[@"phoneNum"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
            params[@"password"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
            params[@"type"] = @"0";
        }
        
        [HttpManager requestWithAPI:@"user/userLogin" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
            
            LoginResponse *response = [[LoginResponse alloc]initWithString:request.responseString error:nil];
            if (response && response.result.resultCode.intValue == 0) {
                
                [self setUserInfoWithLoginResponse:response username:params[@"phoneNum"] password:params[@"password"] loginType:loginType];
                
                [UserInfo sharedInstance].loginType = kLoginTypePhone;
                [UserInfo saveUserId:response.data.userid username:response.data.phone passwordMd5:params[@"password"]];
                
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
        [HttpManager requestWithAPI:@"user/userLogin" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
            
            LoginResponse *response = [[LoginResponse alloc]initWithString:request.responseString error:nil];
            if (response && response.result.resultCode.intValue == 0) {
                
                [self setUserInfoWithLoginResponse:response username:params[@"username"] password:@"" loginType:loginType];
                
                [UserInfo sharedInstance].loginType = kLoginTypeWeixin;
                [UserInfo saveUserId:@"" username:@"" passwordMd5:@""];
                
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
        [UserInfo saveUserId:@"" username:@"" passwordMd5:@""];

        successBlock();
    }
}

+(void)setUserInfoWithLoginResponse:(LoginResponse *)response username:(NSString *)username password:(NSString *)password loginType:(LoginType )loginType
{
    [UserInfo sharedInstance].realName     = response.data.realname;
    [UserInfo sharedInstance].phone        = response.data.phone;
    [UserInfo sharedInstance].password     = response.data.password;
    if (loginType == kLoginTypeWeixin) { //微信登录 phone就是userid
        [UserInfo sharedInstance].phone = [NSString stringWithFormat:@"微信用户%@",response.data.userid];
    }
    [UserInfo sharedInstance].userId       = response.data.userid;
    [UserInfo sharedInstance].identifyCertifyState = response.data.realtype.intValue;
    [UserInfo sharedInstance].agencyName = response.data.occasionName;
    
    [[UserInfo sharedInstance]initContactInfo:response];
}

@end
