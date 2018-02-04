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
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(self.horizonalMargin);
        make.top.equalTo(self.contentView).offset(self.verticalMargin);
        make.right.equalTo(self.contentView).offset(-self.horizonalMargin);
    }];
    
    [super updateConstraints];
}

-(void)setViewModel:(AuctionHallCellViewModel *)viewModel
{
    [super setViewModel:viewModel];
    
    if ([viewModel isMemberOfClass:[AuctionHallChatViewModel class]]) {
        AuctionHallChatViewModel *_viewModel = (AuctionHallChatViewModel *)viewModel;
        
        AuctionHallChatModel *dataModel = _viewModel.dataModel;
        
        NSString *username = [[dataModel.userName mutableCopy]maskingUsername];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@：",username] attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
        [attrStr appendAttributedString:[[NSAttributedString alloc]initWithString:dataModel.chatContent attributes:@{NSForegroundColorAttributeName : BlackColor}]];
        [attrStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"(%@)",[dataModel.time substringFromIndex:11]] attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}]];
        self.label.attributedText = attrStr;
        
        
    }
    
}

-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.textColor = BlackColor;
        _label.numberOfLines = 0;
        _label.font = [[AuctionHallChatViewModel class] textFont];
        _label.layer.masksToBounds = true;
        _label.layer.cornerRadius = 2;
        _label.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:0.5];
        [self.contentView addSubview:_label];
    }
    return _label;
}

@end
