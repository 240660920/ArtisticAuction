//
//  AuctionHallBidModel.h
//  ArtisticAuction
//
//  Created by xieran on 2017/5/16.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "MQTTMessageBaseModel.h"

@interface AuctionHallBidModel : MQTTMessageBaseModel

@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *price;


@end
