//
//  UIView+background.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/10.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "UIView+background.h"

@implementation UIView (background)

+(UIImageView *)backgroundView
{
    UIImageView *background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    background.contentMode = UIViewContentModeTop;
    background.layer.masksToBounds = YES;
    return background;
}

@end
