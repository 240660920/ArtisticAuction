//
//  AdResponse.m
//  ArtisticAucation
//
//  Created by xieran on 16/1/22.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import "AdResponse.h"

@implementation AdModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithDictionary:@{@"imgPath" : @"imageUrl" , @"url" : @"linkUrl" , @"typeid" : @"paramId"}];
}

@end

@implementation AdResponse

@end
