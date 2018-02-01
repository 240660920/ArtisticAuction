//
//  AucationDetailTopView.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationDetailTopView.h"
#import "FullScreenScrollView.h"

#define TitleFont [UIFont systemFontOfSize:16]

@interface AucationDetailTopView ()

@property(nonatomic,strong)FullScreenScrollView *fullScreenScrollView;

@end

@implementation AucationDetailTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(CGFloat )heightForRowWithTitle:(NSString *)title
{
    CGFloat imageHeight = Screen_Width;
    CGFloat labelHeight = [title boundingRectWithSize:CGSizeMake(Screen_Width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : TitleFont} context:nil].size.height;
    
    
    return imageHeight + 15 + labelHeight + 15 + 14 + 73;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(Screen_Width));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageScrollView.mas_bottom).offset(15);
        make.left.equalTo(@10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.equalTo(@10);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(84);
        make.centerY.equalTo(self.promptLabel);
    }];
    
    [self.subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.promptLabel.mas_bottom);
        make.height.equalTo(@73);
    }];
}



-(AAImagesScrollView *)imageScrollView
{
    if (!_imageScrollView) {
        _imageScrollView = [[AAImagesScrollView alloc]init];
        [self addSubview:_imageScrollView];
        
        __weak __typeof(self)weakself = self;
        [_imageScrollView setTapBlock:^(NSArray *imgUrls, NSInteger currentIndex, id dataModel) {
            weakself.fullScreenScrollView.imageUrls = imgUrls;
            weakself.fullScreenScrollView.currentIndex = currentIndex;
            [weakself.fullScreenScrollView show];
        }];
    }
    return _imageScrollView;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = BlackColor;
        _titleLabel.font = TitleFont;
        _titleLabel.numberOfLines = 2;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UILabel *)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc]init];
        _promptLabel.textColor = BlackColor;
        _promptLabel.font = [UIFont systemFontOfSize:14];
        _promptLabel.text = @"当前价格";
        [self addSubview:_promptLabel];
    }
    return _promptLabel;
}

-(UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.textColor = [UIColor colorWithRed:1 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        _promptLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_priceLabel];
    }
    return _priceLabel;
}

-(AucationDetailTopViewSubview *)subview
{
    if (!_subview) {
        _subview = [[NSBundle mainBundle]loadNibNamed:@"AucationDetailTopViewSubview" owner:self options:nil][0];
        _subview.backgroundColor = [UIColor clearColor];
        [self addSubview:_subview];
    }
    return _subview;
}

-(FullScreenScrollView *)fullScreenScrollView
{
    if (!_fullScreenScrollView) {
        _fullScreenScrollView = [[FullScreenScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    }
    return _fullScreenScrollView;
}

@end
