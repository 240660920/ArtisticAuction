//
//  AuctionHallItemIntrolCell.m
//  ArtisticAuction
//
//  Created by xieran on 2017/5/15.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallItemIntrolCell.h"

@interface AuctionHallItemIntrolCell ()

@property(nonatomic,strong)UILabel *label;

@end

@implementation AuctionHallItemIntrolCell

-(void)updateConstraints
{
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(self.verticalMargin);
        make.left.equalTo(self.contentView).offset(self.horizonalMargin);
        make.right.equalTo(self.contentView).offset(-self.horizonalMargin);
    }];
    
    [super updateConstraints];
}

-(void)setViewModel:(AuctionHallCellViewModel *)viewModel
{
    [super setViewModel:viewModel];
    
    if ([viewModel isMemberOfClass:[AuctionHallItemIntroViewModel class]]) {
        AuctionHallItemIntroViewModel *_viewModel = (AuctionHallItemIntroViewModel *)viewModel;
        
        self.label.text = _viewModel.dataModel.text;
    }
}

-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.textColor = RedColor;
        _label.numberOfLines = 0;
        _label.font = [[AuctionHallItemIntroViewModel class] textFont];
        [self.contentView addSubview:_label];
    }
    return _label;
}

@end
