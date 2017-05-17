//
//  AuctionHallBidCell.m
//  ArtisticAuction
//
//  Created by xieran on 2017/5/15.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallBidCell.h"

@implementation AuctionHallBidCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = RedColor;
    }
    return self;
}

@end
