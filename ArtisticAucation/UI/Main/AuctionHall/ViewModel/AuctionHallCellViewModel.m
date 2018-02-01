//
//  AuctionHallCellModel.m
//  ArtisticAuction
//
//  Created by xieran on 2017/5/15.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallCellViewModel.h"
#import "AuctionHallItemIntrolCell.h"
#import "AuctionHallSystemCell.h"
#import "AuctionHallChatCell.h"
#import "AuctionHallBidCell.h"

@implementation AuctionHallCellViewModel

-(NSString *)identifier
{
    return NSStringFromClass([self class]);
}

-(CGFloat)cellHeight
{
    return 0;
}

-(CGFloat)horizonalMargin
{
    return 15.0f;
}

-(CGFloat)verticalMargin
{
    return 10.0f;
}

-(Class)cellClass
{
    return [NSObject class];
}

+(UIFont *)textFont
{
    return [UIFont systemFontOfSize:16];
}

@end

@implementation AuctionHallItemIntroViewModel

-(Class)cellClass
{
    return [AuctionHallItemIntrolCell class];
}

-(CGFloat )cellHeight
{
    if (_cellHeight == 0) {
        CGFloat textHeight = 0;
        textHeight = [self.dataModel.text boundingRectWithSize:CGSizeMake(Screen_Width - 2 * self.horizonalMargin, MAXFLOAT) options:0 | 1 attributes:@{NSFontAttributeName : [[self class] textFont]} context:nil].size.height;
        
        _cellHeight = textHeight + 2 * self.verticalMargin + 2;
    }
    return _cellHeight;
}

@end

@implementation AuctionHallSystemViewModel

-(Class)cellClass
{
    return [AuctionHallSystemCell class];
}

-(CGFloat )cellHeight
{
    if (_cellHeight == 0) {
        CGFloat textHeight = 0;
        textHeight = [self.dataModel.text boundingRectWithSize:CGSizeMake(Screen_Width - 2 * self.horizonalMargin, MAXFLOAT) options:0 | 1 attributes:@{NSFontAttributeName : [[self class]textFont]} context:nil].size.height;
        
        _cellHeight = textHeight + 2 * self.verticalMargin + 2;
    }
    return _cellHeight;
}

@end

@implementation AuctionHallChatViewModel

-(Class)cellClass
{
    return [AuctionHallChatCell class];
}

-(CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        CGFloat textHeight = 0;
        textHeight = [self.dataModel.chatContent boundingRectWithSize:CGSizeMake(Screen_Width - 2 * self.horizonalMargin, MAXFLOAT) options:0 | 1 attributes:@{NSFontAttributeName : [[self class] textFont]} context:nil].size.height;
        
        NSString *userName = self.dataModel.userName;
        CGFloat subtitleHeight = [userName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:0 | 1 attributes:@{NSFontAttributeName : [[self class] subtitleFont]} context:nil].size.height + 2;
        _cellHeight = textHeight + subtitleHeight + 3 * self.verticalMargin;
    }
    return _cellHeight;
}

+(UIFont *)subtitleFont
{
    return [UIFont systemFontOfSize:12];
}

@end

@implementation AuctionHallBidViewModel

-(Class)cellClass
{
    return [AuctionHallBidCell class];
}

-(CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        CGFloat textHeight = 0;
        textHeight = [self.dataModel.price boundingRectWithSize:CGSizeMake(Screen_Width - 2 * self.horizonalMargin, MAXFLOAT) options:0 | 1 attributes:@{NSFontAttributeName : [[self class] textFont]} context:nil].size.height;
        
        NSString *userName = self.dataModel.phone;
        CGFloat subtitleHeight = [userName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:0 | 1 attributes:@{NSFontAttributeName : [[self class] subtitleFont]} context:nil].size.height + 2;
        _cellHeight = textHeight + subtitleHeight + 3 * self.verticalMargin;
    }
    return _cellHeight;
}

+(UIFont *)subtitleFont
{
    return [UIFont systemFontOfSize:12];
}

@end
