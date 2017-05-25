//
//  AuctionHallChatCell.m
//  ArtisticAuction
//
//  Created by xieran on 2017/5/15.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallChatCell.h"

@interface AuctionHallChatCell ()

@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UILabel *userNameLabel;
@property(nonatomic,strong)UILabel *timeLabel;

@end

@implementation AuctionHallChatCell

-(void)updateConstraints
{
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.horizonalMargin);
        make.top.equalTo(self.contentView).offset(self.verticalMargin);
    }];
    
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(self.verticalMargin);
        make.left.equalTo(self.contentView).offset(self.horizonalMargin);
        make.bottom.equalTo(self.contentView).offset(-self.verticalMargin);
        make.right.equalTo(self.contentView).offset(-self.horizonalMargin);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-self.horizonalMargin);
        make.centerY.equalTo(self.userNameLabel);
    }];
    
    [super updateConstraints];
}

-(void)setViewModel:(AuctionHallCellViewModel *)viewModel
{
    [super setViewModel:viewModel];
    
    if ([viewModel isMemberOfClass:[AuctionHallChatViewModel class]]) {
        AuctionHallChatViewModel *_viewModel = (AuctionHallChatViewModel *)viewModel;
        
        AuctionHallChatModel *dataModel = _viewModel.dataModel;
        
        self.label.text = dataModel.chatContent;
        self.userNameLabel.text = dataModel.userName;
        self.timeLabel.text = dataModel.time;
        
    }
    
}

-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.textColor = BlackColor;
        _label.numberOfLines = 0;
        _label.font = [[AuctionHallChatViewModel class] textFont];
        [self.contentView addSubview:_label];
    }
    return _label;
}

-(UILabel *)userNameLabel
{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.textColor = RedColor;
        _userNameLabel.font = [[AuctionHallChatViewModel class]subtitleFont];
        [self.contentView addSubview:_userNameLabel];
    }
    return _userNameLabel;
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [[AuctionHallChatViewModel class]subtitleFont];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

@end
