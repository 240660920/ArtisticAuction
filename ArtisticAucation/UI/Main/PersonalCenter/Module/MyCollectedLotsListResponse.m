//
//  MyCollectedLotsListResponse.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/26.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "MyCollectedLotsListResponse.h"

@implementation MyCollcetedLotDetailItem

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"typeid" : @"itemType" , @"description" : @"descString" , @"lookcount" : @"likeTotals" , @"praiseType" : @"likeType" , @"collectcount" : @"collectTotals" , @"image" : @"images" , @"cname" : @"name" , @"occname" : @"occasion"}];
}

@end

@implementation MyCollectedLotItem

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation MyCollectedLotsListResponse

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end
