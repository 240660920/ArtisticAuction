//
//  AgencyHeaderView.m
//  ArtisticAucation
//
//  Created by xieran on 16/1/7.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import "AgencyHeaderView.h"

#define PreferenceButtonWidth 70
#define PreferenceButtonHeight 40

@interface AgencyHeaderView ()

@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)UILabel *line;

@end

@implementation AgencyHeaderView

+(CGFloat)heightForImage:(UIImage *)image
{
    CGFloat height = image.size.height / image.size.width * Screen_Width + 40;
    return height;
}

-(id)init
{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Width / 2)];
        _imageView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        [self addSubview:_imageView];
        
        self.line.frame = CGRectMake(0, CGRectGetMaxY(self.likeButton.frame), Screen_Width, 0.5);
        
    }
    return self;
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    
    self.imageView.image = image;
    
    CGFloat height = image.size.height / image.size.width * Screen_Width;
    self.imageView.frame = CGRectMake(0, 0, Screen_Width, height);
    
    self.likeButton.frame = CGRectMake(self.likeButton.frame.origin.x, CGRectGetMaxY(self.imageView.frame), PreferenceButtonWidth, PreferenceButtonHeight);
    self.collectButton.frame = CGRectMake(CGRectGetMaxX(self.likeButton.frame), CGRectGetMinY(self.likeButton.frame), PreferenceButtonWidth, PreferenceButtonHeight);
    
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.likeButton.frame), Screen_Width, 0.5);
}

-(UILabel *)line
{
    if (!_line) {
        _line = [[UILabel alloc]init];
        _line.backgroundColor = TableViewSeparateColor;
        [self addSubview:_line];
    }
    return _line;
}

-(LikeButton *)likeButton
{
    if (!_likeButton) {
        _likeButton = [[LikeButton alloc]initWithFrame:CGRectMake(20, Screen_Width / 2, PreferenceButtonWidth, PreferenceButtonHeight)];
        [_likeButton setTitle:@"0" forState:UIControlStateNormal];
        [_likeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self addSubview:_likeButton];
    }
    return _likeButton;
}

-(CollectButton *)collectButton
{
    if (!_collectButton) {
        _collectButton = [[CollectButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.likeButton.frame), Screen_Width / 2, PreferenceButtonWidth, PreferenceButtonHeight)];
        [_collectButton setTitle:@"0" forState:UIControlStateNormal];
        [_collectButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self addSubview:_collectButton];
    }
    return _collectButton;
}

@end
