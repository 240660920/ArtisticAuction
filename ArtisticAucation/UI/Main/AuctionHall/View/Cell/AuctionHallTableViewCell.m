//
//  AuctionHallTableViewCell.m
//  ArtisticAuction
//
//  Created by xieran on 2017/5/15.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallTableViewCell.h"

@interface AuctionHallTableViewCell ()

@property(nonatomic,assign)CGFloat cellHeight;

@end

@implementation AuctionHallTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setViewModel:(AuctionHallCellViewModel *)viewModel
{
    if (self.cellHeight != viewModel.cellHeight) {
        self.cellHeight = viewModel.cellHeight;
        
        [self setNeedsUpdateConstraints];
    }

    self.horizonalMargin = viewModel.horizonalMargin;
    self.verticalMargin = viewModel.verticalMargin;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
