//
//  AuctionHallSystemCell.m
//  ArtisticAuction
//
//  Created by xieran on 2017/5/15.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallSystemCell.h"


@interface AuctionHallSystemCell ()

@property(nonatomic,strong)UILabel *label;

@end

@implementation AuctionHallSystemCell

-(void)updateConstraints
{
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(self.verticalMargin);
        make.left.equalTo(self.contentView).offset(self.horizonalMargin);
        make.bottom.equalTo(self.contentView).offset(-self.verticalMargin);
        make.right.equalTo(self.contentView).offset(-self.horizonalMargin);
    }];
    
    [super updateConstraints];
}

-(void)setViewModel:(AuctionHallCellViewModel *)viewModel
{
    [super setViewModel:viewModel];
    
    if ([viewModel isMemberOfClass:[AuctionHallSyetemViewModel class]]) {
        AuctionHallSyetemViewModel *_viewModel = (AuctionHallSyetemViewModel *)viewModel;
        
        self.label.text = _viewModel.dataModel.text;
    }
}

-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.textColor = BlackColor;
        _label.numberOfLines = 0;
        _label.font = [[AuctionHallSyetemViewModel class]textFont];
        [self.contentView addSubview:_label];
    }
    return _label;
}



@end
