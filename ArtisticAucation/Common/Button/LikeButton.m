//
//  LikeButton.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/23.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "LikeButton.h"

@implementation LikeButton

-(void)didMoveToSuperview
{
    [self setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    
    [self setImage:[UIImage imageNamed:@"like_sel"] forState:UIControlStateSelected];
    
    [self setTitleColor:RedColor forState:UIControlStateNormal];
    [self setTitleColor:RedColor forState:UIControlStateSelected];
    
    [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
}

@end
