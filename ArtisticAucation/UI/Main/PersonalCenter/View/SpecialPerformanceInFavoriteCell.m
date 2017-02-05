//
//  AucationsInFavoriteCell.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/9.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "SpecialPerformanceInFavoriteCell.h"

@implementation SpecialPerformanceInFavoriteCell

- (void)awakeFromNib {
    // Initialization code
    

}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    [self.performanceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@(screenWidth * 7 / 16));
    }];
    
    [self.stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.width.equalTo(@66);
        make.height.equalTo(@21);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView);
        make.height.equalTo(@21);
        make.width.equalTo(@55);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(25);
        make.right.equalTo(self.mas_right).offset(-25);
        make.top.equalTo(self.performanceImageView.mas_bottom).offset(13);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.width.equalTo(@(screenWidth / 3));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(13);
    }];
    
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.width.equalTo(self.likeButton);
    }];
    
    [self.aucationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.width.top.equalTo(self.collectButton);
    }];
}

- (IBAction)like:(id)sender {
    self.likeRequestBlock();
}

- (IBAction)collect:(id)sender {
    self.collectRequestBlock();
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat )heightForRow
{
    return [UIScreen mainScreen].bounds.size.width * 7 / 16 + 75;
}

#pragma mark Properties
-(UIImageView *)performanceImageView
{
    if (!_performanceImageView) {
        _performanceImageView = [[UIImageView alloc]init];
        _performanceImageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation"]];
        _performanceImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_performanceImageView];
    }
    return _performanceImageView;
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:19];
        _nameLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

-(LikeButton *)likeButton
{
    if (!_likeButton) {
        _likeButton = [LikeButton buttonWithType:UIButtonTypeCustom];
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_likeButton setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
        _likeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_likeButton setImage:[UIImage imageNamed:@"people_amount"] forState:UIControlStateNormal];
        [_likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_likeButton];
    }
    return _likeButton;
}

-(CollectButton *)collectButton
{
    if (!_collectButton) {
        _collectButton = [CollectButton buttonWithType:UIButtonTypeCustom];
        _collectButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_collectButton setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
        _collectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_collectButton setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
        [_collectButton addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_collectButton];
    }
    return _collectButton;
}

-(UIButton *)aucationButton
{
    if (!_aucationButton) {
        _aucationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _aucationButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_aucationButton setTitleColor:RedColor forState:UIControlStateNormal];
        _aucationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_aucationButton setImage:[UIImage imageNamed:@"aucations_amount"] forState:UIControlStateNormal];
        [self.contentView addSubview:_aucationButton];
    }
    return _aucationButton;
}

-(UIImageView *)stateImageView
{
    if (!_stateImageView) {
        _stateImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_stateImageView];
    }
    return _stateImageView;
}

-(UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.font = [UIFont systemFontOfSize:14];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_stateLabel];
    }
    return _stateLabel;
}

@end
