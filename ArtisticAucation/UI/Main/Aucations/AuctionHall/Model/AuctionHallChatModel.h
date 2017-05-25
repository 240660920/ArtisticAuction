//
//  AuctionHallChatModel.h
//  ArtisticAuction
//
//  Created by xieran on 2017/5/16.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallBaseModel.h"

@interface AuctionHallChatModel : AuctionHallBaseModel

@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *chatContent;

@end
