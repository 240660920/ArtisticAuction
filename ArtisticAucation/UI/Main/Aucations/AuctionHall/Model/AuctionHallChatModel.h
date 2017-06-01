//
//  AuctionHallChatModel.h
//  ArtisticAuction
//
//  Created by xieran on 2017/5/16.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "MQTTMessageBaseModel.h"

@interface AuctionHallChatModel : MQTTMessageBaseModel

@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *chatContent;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *tel;
@property(nonatomic,copy)NSString *date;
@end
