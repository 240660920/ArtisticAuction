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

#define UserInfoArchivePath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"UserInfo"]

@implementation UserInfo

+(UserInfo *)sharedInstance
{
    if (!userInfo) {
        userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:UserInfoArchivePath];
        if (!userInfo) {
            userInfo = [[UserInfo alloc]init];
            userInfo.occasionList = [[NSMutableArray alloc]init];
        }
    }
    return userInfo;
}

+(void)clearUserInfo
{
    userInfo = nil;
    
    [[NSFileManager defaultManager]removeItemAtPath:UserInfoArchivePath error:nil];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.guid = [aDecoder decodeObjectForKey:@"guid"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.realName = [aDecoder decodeObjectForKey:@"realName"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.performanceName = [aDecoder decodeObjectForKey:@"performanceName"];
        self.weixinUniqueId = [aDecoder decodeObjectForKey:@"weixinUniqueId"];
        self.agencyName = [aDecoder decodeObjectForKey:@"agencyName"];
        self.aid = [aDecoder decodeObjectForKey:@"aid"];
        self.agencyImage = [aDecoder decodeObjectForKey:@"agencyImage"];
        self.identifyCertifyState = [[aDecoder decodeObjectForKey:@"IdentityCertifyState"]intValue];
        self.loginType = [[aDecoder decodeObjectForKey:@"loginType"]intValue];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_guid forKey:@"guid"];
    [aCoder encodeObject:_userId forKey:@"userId"];
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeObject:_realName forKey:@"realName"];
    [aCoder encodeObject:_phone forKey:@"phone"];
    [aCoder encodeObject:_performanceName forKey:@"performanceName"];
    [aCoder encodeObject:_weixinUniqueId forKey:@"weixinUniqueId"];
    [aCoder encodeObject:_agencyName forKey:@"agencyName"];
    [aCoder encodeObject:_aid forKey:@"aid"];
    [aCoder encodeObject:_agencyImage forKey:@"agencyImage"];
    [aCoder encodeObject:@(_identifyCertifyState) forKey:@"IdentityCertifyState"];
    [aCoder encodeObject:@(_loginType) forKey:@"loginType"];
}

-(void)addContactInfo:(LoginResponse *)loginResponse
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

-(void)archive
{
    [NSKeyedArchiver archiveRootObject:self toFile:UserInfoArchivePath];
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
