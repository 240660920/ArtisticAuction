//
//  AgencyItemResponse.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/23.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AgencyItemResponse.h"

@implementation AgencyItem

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"praiseType" : @"likeType" , @"enterTotals" : @"likeTotals"}];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation AgencyItemResponse

@end
