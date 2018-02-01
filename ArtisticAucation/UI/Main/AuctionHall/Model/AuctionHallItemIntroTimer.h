//
//  AuctionHallItemIntroTimer.h
//  ArtisticAuction
//
//  Created by xieran on 2017/5/19.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuctionHallCurrentItemModel.h"

@interface AuctionHallItemIntroTimer : NSObject

@property(nonatomic,strong)AuctionHallCurrentItemModel *model;

@property(nonatomic,copy)void(^insertModelBlock)(NSString *text);

@end
