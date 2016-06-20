//
//  MyCollectedPerformancesResponse.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/26.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "MyCollectedPerformancesResponse.h"

@implementation MyCollectedPerformancesDetail

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"enterTotals" : @"likeTotals" , @"praiseType" : @"likeType"}];
}

@end

@implementation MyCollectedPerformanceItem

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end


@implementation MyCollectedPerformancesResponse

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
