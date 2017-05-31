//
//  AuctionHallBidModel.m
//  ArtisticAuction
//
//  Created by xieran on 2017/5/16.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallBidModel.h"

@implementation AuctionHallBidModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"price" : @"nowprice",
                                                                 @"phone" : @"tel",
                                                                 @"time" : @"date"}];
}

@end
