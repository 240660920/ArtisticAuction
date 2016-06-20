//
//  CollectButton.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/23.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "CollectButton.h"

@implementation CollectButton

-(void)didMoveToSuperview
{
    [self setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateNormal];
    
    [self setImage:[UIImage imageNamed:@"favorite_sel"] forState:UIControlStateSelected];
    
    [self setTitleColor:RedColor forState:UIControlStateNormal];
    [self setTitleColor:RedColor forState:UIControlStateSelected];
    
    [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
}

@end
