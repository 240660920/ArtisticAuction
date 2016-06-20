//
//  AboutUsViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/16.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@property(nonatomic,strong)UILabel *copRightLabel;
@property(nonatomic,strong)UILabel *introLabel;

@end

@implementation AboutUsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Screen_Width - 80));
        make.top.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
    }];
    
    [self.copRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
    }];
}

-(UILabel *)introLabel
{
    if (!_introLabel) {
        _introLabel = [[UILabel alloc]init];
        _introLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        _introLabel.font = [UIFont systemFontOfSize:14];
        _introLabel.textAlignment = NSTextAlignmentCenter;
        _introLabel.numberOfLines = 0;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:10];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"APP简介\n\n" attributes:@{NSForegroundColorAttributeName : _introLabel.textColor , NSFontAttributeName : _introLabel.font}];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:@"艺术+家APP是江苏公共文化产业开发有限公司为实现“让艺术品走进千家万户”这一伟大梦想所投资开发的手机在线拍卖平台。\n艺术+家将深入挖掘艺术品的潜在魅力，整合线上线下资源抵制传统拍卖陋习，为人们搭建一个注重诚信、价格合理、品类齐全的拍卖平台。让所有人都能轻松收藏到心爱的艺术品。" attributes:@{NSForegroundColorAttributeName : _introLabel.textColor , NSFontAttributeName : _introLabel.font , NSParagraphStyleAttributeName : paragraphStyle}];
        [str appendAttributedString:str2];
        
        _introLabel.attributedText = str;
        
        [self.view addSubview:_introLabel];
    }
    return _introLabel;
}

-(UILabel *)copRightLabel
{
    if (!_copRightLabel) {
        _copRightLabel = [[UILabel alloc]init];
        _copRightLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        _copRightLabel.font = [UIFont systemFontOfSize:14];
        _copRightLabel.numberOfLines = 0;
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc]init];
        para.lineSpacing = 5;
        para.alignment = NSTextAlignmentCenter;
        _copRightLabel.attributedText = [[NSAttributedString alloc]initWithString:@"©2016 江苏公共文化产业开发有限公司\n商务合作 13372003774" attributes:@{NSParagraphStyleAttributeName : para}];
        [self.view addSubview:_copRightLabel];
    }
    return _copRightLabel;
}

@end
