//
//  RemindButton.m
//  ArtisticAucation
//
//  Created by xieran on 15/12/6.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "RemindButton.h"

@implementation RemindButton

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (!selected) {
        [self setTitle:@"提醒" forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"remind_clock"] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    else{
        [self setTitle:@"已设置提醒" forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
    }
}

@end
