//
//  LaunchAdResponse.m
//  ArtisticAuction
//
//  Created by xieran on 16/8/23.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import "LaunchAdResponse.h"

@implementation LaunchAdDataModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"4inch" : @"img_4inch" , @"4.7inch" : @"img_47inch" , @"5.5inch" : @"img_55inch"}];
}

@end

@implementation LaunchAdResponse


@end
