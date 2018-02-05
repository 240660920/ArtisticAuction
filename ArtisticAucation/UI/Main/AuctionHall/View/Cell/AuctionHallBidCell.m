//
//  AuctionHallBidCell.m
//  ArtisticAuction
//
//  Created by xieran on 2017/5/15.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallBidCell.h"
#import "BidManager.h"

@interface AuctionHallBidCell ()

@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UILabel *userNameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIImageView *icon;

@end

@implementation AuctionHallBidCell

-(void)updateConstraints
{
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.horizonalMargin);
        make.top.equalTo(self.contentView).offset(self.verticalMargin);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameLabel.mas_right);
        make.centerY.equalTo(self.userNameLabel);
        make.width.height.equalTo(@20);
    }];
    
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userNameLabel);
        make.left.equalTo(self.icon.mas_right);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label.mas_right);
        make.centerY.equalTo(self.userNameLabel);
    }];
    
    [super updateConstraints];
}

-(void)setViewModel:(AuctionHallCellViewModel *)viewModel
{
    [super setViewModel:viewModel];
        
    if ([viewModel isMemberOfClass:[AuctionHallBidViewModel class]]) {
        AuctionHallBidViewModel *_viewModel = (AuctionHallBidViewModel *)viewModel;
        
        AuctionHallBidModel *dataModel = _viewModel.dataModel;
        
        self.label.text = [NSString stringWithFormat:@"¥%0.f",dataModel.price.floatValue];
        self.userNameLabel.text = [NSString stringWithFormat:@"%@：",[dataModel.phone maskingUsername]];
        self.timeLabel.text = [NSString stringWithFormat:@"(%@)",[dataModel.time substringFromIndex:11]];
    }
    
}

-(UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc]init];
        _icon.image = [UIImage imageNamed:@"bid_icon"];
        [self.contentView addSubview:_icon];
    }
    return _icon;
}

-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.textColor = RedColor;
        _label.numberOfLines = 0;
        _label.font = [[AuctionHallBidViewModel class] textFont];
        [self.contentView addSubview:_label];
    }
    return _label;
}

-(UILabel *)userNameLabel
{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.textColor = BlackColor;
        _userNameLabel.font = [[AuctionHallBidViewModel class]textFont];
        [self.contentView addSubview:_userNameLabel];
    }
    return _userNameLabel;
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [[AuctionHallBidViewModel class]textFont];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

@end
