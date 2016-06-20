//
//  LoginResponse.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "LoginResponse.h"

@implementation LoginResponseDataModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"address" : @"contactAddresses" , @"phoneNum" : @"contactPhoneNums" , @"fullname" : @"contactNames" , @"occasionname" : @"occasionName"}];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation LoginResponse

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"Occasion" : @"occasion"}];
}

@end
