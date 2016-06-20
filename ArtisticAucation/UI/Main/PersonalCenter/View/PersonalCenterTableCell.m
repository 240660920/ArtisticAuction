//
//  PersonalCenterTableCell.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/30.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "PersonalCenterTableCell.h"

@implementation PersonalCenterTableCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(20, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
    
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 15, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
}

@end
