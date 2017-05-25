//
//  UserInfo.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/6.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "UserInfo.h"
#import <objc/runtime.h>
#import "AddressInfo.h"

UserInfo *userInfo;

@implementation UserInfo

+(UserInfo *)sharedInstance
{
    if (!userInfo) {
        userInfo = [[UserInfo alloc]init];
        userInfo.userId = [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
        userInfo.occasionList = [[NSMutableArray alloc]init];

        if ([[NSUserDefaults standardUserDefaults]integerForKey:@"LoginType"]) {
            userInfo.loginType = [[NSUserDefaults standardUserDefaults]integerForKey:@"LoginType"];
        }
        else{
            userInfo.loginType = kLoginTypeTraveller;
        }
    }
    return userInfo;
}

+(void)clearUserInfo
{
    [UserInfo sharedInstance].userId = nil;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(void)saveUserId:(NSString *)userid username:(NSString *)username passwordMd5:(NSString *)passwordMd5
{
    [[NSUserDefaults standardUserDefaults]setObject:userid forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults]setObject:username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults]setObject:passwordMd5 forKey:@"password"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)initContactInfo:(LoginResponse *)loginResponse
{
    NSArray *names = loginResponse.data.contactNames;
    NSArray *phoneNums = loginResponse.data.contactPhoneNums;
    NSArray *addresses = loginResponse.data.contactAddresses;
    
    _contactInfos = [[NSMutableArray alloc]init];
    for (int i = 0; i < names.count; i++) {
        AddressInfo *info = [[AddressInfo alloc]init];
        info.name = names[i];
        info.phoneNum = phoneNums[i];
        info.address = addresses[i];
        
        [_contactInfos addObject:info];
    }
}

-(void)setLoginType:(LoginType)loginType
{
    _loginType = loginType;
    
    [[NSUserDefaults standardUserDefaults]setInteger:loginType forKey:@"LoginType"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *)guid
{
    if (self.loginType == kLoginTypePhone) {
        return [UserInfo sharedInstance].phone;
    }
    else if (self.loginType == kLoginTypeWeixin){
        return [UserInfo sharedInstance].userId;
    }
    else if (self.loginType == kLoginTypeTraveller){
        return [NSUUID UUID].UUIDString;
    }
    else{
        return @"";
    }
}

@end
