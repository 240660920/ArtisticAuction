//
//  AuctionHallCountDownView.m
//  ArtisticAuction
//
//  Created by xieran on 2017/5/17.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallCountDownView.h"

@interface AuctionHallCountDownView ()

@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSTimeInterval second;

@end

@implementation AuctionHallCountDownView

-(id)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        self.userInteractionEnabled = NO;
    }
    return self;
}

-(void)showWithSecond:(NSInteger)second
{
    self.second = second;
    
    [UIView beginAnimations:nil context:nil];
    self.layer.opacity = 1;
    [UIView commitAnimations];
    
    [self.timer fire];
    
    [self.superview bringSubviewToFront:self];
}

-(void)stop
{
    [self.timer invalidate];
    self.timer = nil;
    
    [UIView beginAnimations:nil context:nil];
    self.layer.opacity = 0;
    [UIView commitAnimations];
}

-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.layer.masksToBounds = YES;
        _label.layer.cornerRadius = 60;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.layer.borderColor = RedColor.CGColor;
        _label.layer.borderWidth = 1;
        [_label setTextColor:RedColor];
        [_label setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.7]];
        [self addSubview:_label];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@120);
            make.centerX.centerY.equalTo(self);
        }];
    }
    return _label;
}

-(NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",(long)self.second] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:30]}];
            NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"s" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]}];
            [attrStr appendAttributedString:str];
            
            self.label.attributedText = attrStr;
            
            self.second--;
            
            if (self.second < 0) {
                [_timer invalidate];
                _timer = nil;                
            }
        }];
    }
    return _timer;
}

@end
