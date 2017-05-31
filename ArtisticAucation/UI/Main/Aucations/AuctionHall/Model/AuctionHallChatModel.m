//
//  AuctionHallChatModel.m
//  ArtisticAuction
//
//  Created by xieran on 2017/5/16.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallChatModel.h"

@implementation AuctionHallChatModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"chatContent" : @"message",
                                                                 @"userName" : @"tel",
                                                                 @"time" : @"date"}];
}

@end
