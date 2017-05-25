//
//  AuctionHallCurrentItemModel.m
//  ArtisticAuction
//
//  Created by xieran on 2017/5/18.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallCurrentItemModel.h"

@implementation AuctionHallCurrentItemOccasionModel

@end

@implementation AuctionHallCurrentItemDataModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"analyse" : @"description" ,
                                                                 @"occasion" : @"occname"}];
}

@end

@implementation AuctionHallCurrentItemModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"data" : @"msg" , @"index" : @"number"}];
}

@end
