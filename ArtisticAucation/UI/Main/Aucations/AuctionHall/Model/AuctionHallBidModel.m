//
//  AuctionHallBidModel.m
//  ArtisticAuction
//
//  Created by xieran on 2017/5/16.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallBidModel.h"

@implementation AuctionHallBidModel

-(NSString *)price
{
    return [NSString stringWithFormat:@"¥%@",_price];
}

@end
