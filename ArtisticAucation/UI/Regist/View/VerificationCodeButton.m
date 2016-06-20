//
//  VerificationCodeButton.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/29.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "VerificationCodeButton.h"
#import "VerificationCodeManager.h"

@interface VerificationCodeButton ()

@end

@implementation VerificationCodeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        
        NSInteger timeLeft = [VerificationCodeManager sharedInstance].timeForRegist;
        if (timeLeft != VerificationCodeColdDurarion) {
            self.enabled = NO;
        }
        else{
            self.enabled = YES;
        }
    }
    return self;
}

-(void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (enabled) {
        [self setTitle:@"发送验证码" forState:UIControlStateNormal];
    }
    else{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(textChanged) userInfo:nil repeats:YES];
        [self.timer fire];
    }
}

-(void)textChanged
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger timeLeft = [VerificationCodeManager sharedInstance].timeForRegist;
        NSLog(@"%d",timeLeft);
        if (timeLeft < 0) {
            [self.timer invalidate];
            [self setEnabled:YES];
            timeLeft = 0;
        }
        [self setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)timeLeft] forState:UIControlStateDisabled];
    });
}

@end
