//
//  AucationDetailTextCell.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationDetailTextCell.h"

@interface AucationDetailTextCell ()

@end

@implementation AucationDetailTextCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.accessoryView.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
}

-(UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.font = [UIFont systemFontOfSize:14];
        _leftLabel.textColor = BlackColor;
        [self.contentView addSubview:_leftLabel];
    }
    return _leftLabel;
}

-(UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.font = [UIFont systemFontOfSize:14];
        _rightLabel.textColor = BlackColor;
        _rightLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_rightLabel];
    }
    return _rightLabel;
}

@end
