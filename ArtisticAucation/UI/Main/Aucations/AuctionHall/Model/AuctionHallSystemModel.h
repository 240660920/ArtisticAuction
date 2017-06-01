//
//  AuctionHallSystemModel.h
//  ArtisticAuction
//
//  Created by xieran on 2017/5/16.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "MQTTMessageBaseModel.h"

@interface AuctionHallSystemModel : MQTTMessageBaseModel

@property(nonatomic,copy)NSString *text;

@end
