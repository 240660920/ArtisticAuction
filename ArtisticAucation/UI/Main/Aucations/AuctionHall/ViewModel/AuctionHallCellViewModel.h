//
//  AuctionHallCellModel.h
//  ArtisticAuction
//
//  Created by xieran on 2017/5/15.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AuctionHallCurrentItemModel.h"
#import "AuctionHallChatModel.h"
#import "AuctionHallSystemModel.h"
#import "AuctionHallBidModel.h"

@protocol AuctionHallCellModelProtocol <NSObject>

@required

-(Class)cellClass;

-(CGFloat )cellHeight;

@optional

-(NSString *)identifier;

@end

@interface AuctionHallCellViewModel : NSObject<AuctionHallCellModelProtocol>
{
    CGFloat _cellHeight;
}

@property(nonatomic,assign)CGFloat verticalMargin;
@property(nonatomic,assign)CGFloat horizonalMargin;
@property(nonatomic,assign)CGFloat cellHeight;

+(UIFont *)textFont;

@end


//切换拍品时的拍品介绍 红字
@interface AuctionHallItemIntroViewModel : AuctionHallCellViewModel<AuctionHallCellModelProtocol>

@property(nonatomic,strong)AuctionHallItemIntrolModel *dataModel;

@end

//倒计时、结束 等系统事件
@interface AuctionHallSystemViewModel : AuctionHallCellViewModel<AuctionHallCellModelProtocol>

@property(nonatomic,strong)AuctionHallSystemModel *dataModel;

@end

//聊天
@interface AuctionHallChatViewModel : AuctionHallCellViewModel<AuctionHallCellModelProtocol>

@property(nonatomic,strong)AuctionHallChatModel *dataModel;

+(UIFont *)subtitleFont;

@end

//出价
@interface AuctionHallBidViewModel : AuctionHallCellViewModel<AuctionHallCellModelProtocol>

@property(nonatomic,strong)AuctionHallBidModel *dataModel;

@end
