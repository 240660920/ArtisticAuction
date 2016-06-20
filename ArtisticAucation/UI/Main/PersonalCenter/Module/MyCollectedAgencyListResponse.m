//
//  MyFavoritesResponse.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/20.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "MyCollectedAgencyListResponse.h"

@implementation MyCollectedAgencyDetailItem

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"praiseType" : @"likeType" , @"enterTotals" : @"likeTotals"}];
}

@end

@implementation MyCollectedAgencyDataModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"description" : @"title"}];
}

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation MyCollectedAgencyListResponse

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
