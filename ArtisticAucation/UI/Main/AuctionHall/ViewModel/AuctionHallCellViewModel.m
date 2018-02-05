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
    return [UIFont systemFontOfSize:14];
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
        
        _cellHeight = textHeight + self.verticalMargin + 2;
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

-(NSString *)content
{
    return [NSString stringWithFormat:@"%@：%@(%@)",[self.dataModel.userName maskingUsername],self.dataModel.chatContent,[self.dataModel.time substringFromIndex:11]];
}

-(CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        NSString *content = [self content];
        
        _cellHeight = [content boundingRectWithSize:CGSizeMake(Screen_Width - 2 * self.horizonalMargin, MAXFLOAT) options:0 | 1 attributes:@{NSFontAttributeName : [[self class] textFont]} context:nil].size.height + self.verticalMargin;
    }
    return _cellHeight;
}

@end

@implementation AuctionHallBidViewModel

-(Class)cellClass
{
    return [AuctionHallBidCell class];
}

-(CGFloat)cellHeight
{
    return 30;
}

+(UIFont *)textFont
{
    return [UIFont boldSystemFontOfSize:14];
}

@end
