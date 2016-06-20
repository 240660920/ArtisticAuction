//
//  PayTableViewCell.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/19.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "PayTableViewCell.h"

@interface PayTableViewCell ()

@property(nonatomic,strong)UILabel *leftLabel;
@property(nonatomic,strong)UILabel *rightLabel;

@end

@implementation PayTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
}

-(void)setCellType:(PayTableViewCellType)cellType
{
    _cellType = cellType;
    
    if (cellType == PayTableViewCellTypeCheckbox) {
        self.rightLabel.hidden = YES;
        self.checkBox.hidden = NO;
    }
    else{
        self.rightLabel.hidden = NO;
        self.checkBox.hidden = YES;
    }
}

-(void)setLeftTitle:(NSString *)leftTitle
{
    _leftTitle = leftTitle;
    
    self.leftLabel.text = leftTitle;
}

-(void)setRightTitle:(NSString *)rightTitle
{
    _rightTitle = rightTitle;
    
    NSArray *components = [rightTitle componentsSeparatedByString:@"."];
    if (components.count == 1) {
        self.rightLabel.textColor = BlackColor;
        self.rightLabel.text = rightTitle;
    }
    else if (components.count == 2){
        UIColor *textColor = self.cellType == PayTableViewCellTypeWithBlackLabel ? BlackColor : [UIColor colorWithRed:255.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:components[0] attributes:@{NSForegroundColorAttributeName : textColor , NSFontAttributeName : [UIFont systemFontOfSize:16]}];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@".%@",components[1]] attributes:@{NSForegroundColorAttributeName : textColor , NSFontAttributeName : [UIFont systemFontOfSize:12]}];
        [str1 appendAttributedString:str2];
        
        self.rightLabel.attributedText = str1;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIButton *)checkBox
{
    if (!_checkBox) {
        _checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBox setImage:[UIImage imageNamed:@"hook"] forState:UIControlStateSelected];
        [_checkBox setImage:nil forState:UIControlStateNormal];
        [self.contentView addSubview:_checkBox];
    }
    return _checkBox;
}

-(UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.font = [UIFont systemFontOfSize:16];
        _leftLabel.textColor = BlackColor;
        [self.contentView addSubview:_leftLabel];
    }
    return _leftLabel;
}

-(UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.font = [UIFont systemFontOfSize:16];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_rightLabel];
    }
    return _rightLabel;
}

@end
