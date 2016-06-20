//
//  ImageViewWithDealState.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/30.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "ImageViewWithDealState.h"

@interface ImageViewWithDealState ()

@property(nonatomic,retain)UIImageView *stateImageView;
@property(nonatomic,retain)UILabel *stateLabel;

@end

@implementation ImageViewWithDealState

-(void)setDealState:(DealState)dealState
{
    NSString *stateString = nil;
    UIImage *stateImage = nil;
    
    switch (dealState) {
        case DealNotStart:
        {
            stateString = @"预展中";
            stateImage = [UIImage imageNamed:@"lot_not_started"];
        }
            break;
        case DealOngoing:
        case DealOngoing_:
        {
            stateString = @"拍卖中";
            stateImage = [UIImage imageNamed:@"lot_ongoing"];
        }
            break;
        case DealFinished:
        {
            stateString = nil;
            stateImage = nil;
        }
            break;
        case DealFailed:
        {
            stateString = nil;
            stateImage = nil;
        }
            break;
        default:
            break;
    }
    
    self.stateImageView.image = stateImage;
    self.stateLabel.text = stateString;
}

-(UIImageView *)stateImageView
{
    if (!_stateImageView) {
        _stateImageView = [[UIImageView alloc]init];
        [self addSubview:_stateImageView];
    }
    
    [_stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
    }];
    
    return _stateImageView;
}

-(UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.font = [UIFont systemFontOfSize:11];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = [UIColor whiteColor];
        [self addSubview:_stateLabel];
        
        [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self.stateImageView).offset(-3);
            make.height.equalTo(self.stateImageView);
        }];
    }
    return _stateLabel;
}

@end
