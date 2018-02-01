//
//  CountDownView.m
//  ArtisticAucation
//
//  Created by xieran on 15/12/24.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "CountDownView.h"

@interface CountDownView ()

@property(nonatomic,strong)UIView *countDownView;
@property(nonatomic,strong)UIButton *dayView;
@property(nonatomic,strong)UIButton *hourView;
@property(nonatomic,strong)UIButton *minuteView;
@property(nonatomic,strong)UIButton *secondView;

@property(nonatomic,strong)UIButton *promptButton; //距离开拍

@property(nonatomic,strong)UILabel *stateLabel;

@property(nonatomic,strong)UIFont *titleFont;
@property(nonatomic,strong)UIColor *titleColor;
@property(nonatomic,strong)UIImage *rectangleImage;

@property(nonatomic,strong)NSTimer *timer;

@end

@implementation CountDownView

-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

-(id)init
{
    if (self = [super init]) {
        [self config];
    }
    return self;
}

-(void)awakeFromNib
{
    [self config];
}

-(void)config
{
    self.titleFont = [UIFont systemFontOfSize:12];
    self.titleColor = [UIColor whiteColor];
    self.rectangleImage = [UIImage imageNamed:@"count_down_time_bg"];
}

-(void)refresh
{
    if (self.aucationState == DisplayTypePreDisplay) {
        NSTimeInterval leftTimeInterval = [TimeManager timeIntervalBetweenServerTimeAndTime:self.startTime];
        if (leftTimeInterval > 0) {
            [self countDownStart];
        }
        else{
            [self countDownFinished];
            self.stateLabel.text = @"即将开始";
        }
    }
    else if (self.aucationState == DisplayTypeOngoing){
        [self countDownFinished];
        
        if (self.itemState == DealNotStart) {
            self.stateLabel.text = @"即将开始";
        }
        else if (self.itemState == DealOngoing || self.itemState == DealOngoing_){
            self.stateLabel.text = @"正在进行中";
        }
        else if (self.itemState == DealFinished){
            self.stateLabel.text = @"成交";
        }
        else if (self.itemState == DealFailed){
            self.stateLabel.text = @"流拍";
        }
    }
    else if (self.aucationState == DisplayTypeEnded){
        [self countDownFinished];
        
        if (self.itemState == DealFinished) {
            self.stateLabel.text = @"成交";
        }
        else if (self.itemState == DealFailed){
            self.stateLabel.text = @"流拍";
        }
    }
    else{
        if (self.itemState == DealNotStart) {
            [self countDownStart];
        }
        else if (self.itemState == DealOngoing || self.itemState == DealOngoing_){
            [self countDownFinished];
            self.stateLabel.text = @"正在进行中";
        }
        else if (self.itemState == DealFinished){
            [self countDownFinished];
            self.stateLabel.text = @"成交";
        }
        else if(self.itemState == DealFailed){
            [self countDownFinished];
            self.stateLabel.text = @"流拍";
        }
    }
}






-(void)countDownStart
{
    self.stateLabel.hidden = YES;
    self.promptButton.hidden = NO;
    self.countDownView.hidden = NO;
    [self viewWithTag:1000].hidden = NO;
    [self viewWithTag:2000].hidden = NO;
    
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

-(void)countDownFinished
{
    [self.timer invalidate];
    self.timer = nil;
    
    self.stateLabel.hidden = NO;
    self.stateLabel.text = nil;
    
    self.countDownView.hidden = YES;
    self.promptButton.hidden = YES;
    [self viewWithTag:1000].hidden = YES;
    [self viewWithTag:2000].hidden = YES;
}

-(void)countDown
{
    NSTimeInterval leftTimeInterval = [TimeManager timeIntervalBetweenServerTimeAndTime:self.startTime];
    int days = leftTimeInterval / (24 * 3600);
    int hours = (leftTimeInterval - days * 24 * 3600) / 3600;
    int minutes = (leftTimeInterval - days * 24 * 3600 - hours * 3600) / 60;
    int seconds = leftTimeInterval - days * 24 * 3600 - hours * 3600 - minutes * 60;
    
    NSString *daysString = [NSString stringWithFormat:@"%d天",days];
    NSString *hoursString = [NSString stringWithFormat:@"%02d",hours];
    NSString *minutesString = [NSString stringWithFormat:@"%02d",minutes];
    NSString *secondsString = [NSString stringWithFormat:@"%02d",seconds];
    
    [self.dayView setTitle:daysString forState:UIControlStateNormal];
    [self.hourView setTitle:hoursString forState:UIControlStateNormal];
    [self.minuteView setTitle:minutesString forState:UIControlStateNormal];
    [self.secondView setTitle:secondsString forState:UIControlStateNormal];
    
    if (leftTimeInterval <= 0) {
        [self countDownFinished];
        self.stateLabel.text = @"即将开始";
        [self.timer invalidate];
    }
    
}

-(CGSize )sizeWithText:(NSString *)text
{
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 10) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.titleFont} context:nil].size;
}

-(UIButton *)dayView
{
    if (!_dayView) {
        _dayView = [[UIButton alloc]init];
        [_dayView setBackgroundImage:[self.rectangleImage stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        _dayView.titleLabel.font = self.titleFont;
        [_dayView setTitleColor:self.titleColor forState:UIControlStateNormal];
        _dayView.userInteractionEnabled = NO;
        [self.countDownView addSubview:_dayView];
        
        [_dayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.width.equalTo(@28);
            make.height.equalTo(self.countDownView);
            make.left.equalTo(self).offset(2);
        }];
    }
    return _dayView;
}

-(UIButton *)hourView
{
    if (!_hourView) {
        _hourView = [[UIButton alloc]init];
        [_hourView setBackgroundImage:[self.rectangleImage stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        _hourView.titleLabel.font = self.titleFont;
        [_hourView setTitleColor:self.titleColor forState:UIControlStateNormal];
        _hourView.userInteractionEnabled = NO;
        [self.countDownView addSubview:_hourView];
        
        [_hourView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.height.equalTo(self.countDownView);
            make.left.equalTo(self.dayView.mas_right).offset(15);
            make.width.equalTo(@18);
            
        }];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @":";
        label.font = self.titleFont;
        label.textColor = RedColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 1000;
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.countDownView);
            make.left.equalTo(_hourView.mas_right);
            make.width.equalTo(@15);
        }];
    }
    return _hourView;
}

-(UIButton *)minuteView
{
    if (!_minuteView) {
        _minuteView = [[UIButton alloc]init];
        [_minuteView setBackgroundImage:[self.rectangleImage stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        _minuteView.titleLabel.font = self.titleFont;
        [_minuteView setTitleColor:self.titleColor forState:UIControlStateNormal];
        _minuteView.userInteractionEnabled = NO;
        [self.countDownView addSubview:_minuteView];
        
        [_minuteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.hourView.mas_right).offset(15);
            make.bottom.height.equalTo(self.countDownView);
            make.width.equalTo(@18);
        }];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @":";
        label.font = self.titleFont;
        label.textColor = RedColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 2000;
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.countDownView);
            make.left.equalTo(_minuteView.mas_right);
            make.width.equalTo(@15);
        }];
    }
    return _minuteView;
}

-(UIButton *)secondView
{
    if (!_secondView) {
        _secondView = [[UIButton alloc]init];
        [_secondView setBackgroundImage:[self.rectangleImage stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        _secondView.titleLabel.font = self.titleFont;
        [_secondView setTitleColor:self.titleColor forState:UIControlStateNormal];
        _secondView.userInteractionEnabled = NO;
        [self.countDownView addSubview:_secondView];
        
        [_secondView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.bottom.equalTo(self);
            make.width.equalTo(@18);
            make.left.equalTo(self.minuteView.mas_right).offset(15);
        }];
    }
    return _secondView;
}

-(UIView *)countDownView
{
    if (!_countDownView) {
        _countDownView = [[UIView alloc]init];
        _countDownView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _countDownView.backgroundColor = [UIColor clearColor];
        [self addSubview:_countDownView];
        
        [_countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@15);
        }];
    }
    return _countDownView;
}

-(UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _stateLabel.font = [UIFont systemFontOfSize:14];
        _stateLabel.textColor = RedColor;
        _stateLabel.hidden = YES;
        [self addSubview:_stateLabel];
    }
    return _stateLabel;
}

-(UIButton *)promptButton
{
    if (!_promptButton) {
        _promptButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_promptButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_promptButton setTitleColor:RedColor forState:UIControlStateNormal];
        [_promptButton setImage:[UIImage imageNamed:@"count_down_icon"] forState:UIControlStateNormal];
        [_promptButton setTitle:@"距离开拍" forState:UIControlStateNormal];
        [self addSubview:_promptButton];
        
        [_promptButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
        }];
    }
    return _promptButton;
}

@end
