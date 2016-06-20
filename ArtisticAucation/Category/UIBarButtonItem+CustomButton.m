//
//  UIBarButtonItem+CustomButton.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/24.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "UIBarButtonItem+CustomButton.h"

@implementation UIBarButtonItem (CustomButton)
@dynamic customButton;

-(void)setCustomButton:(UIButton *)customButton
{

}

-(UIButton *)customButton
{
    return (UIButton *)self.customView;
}

@end
