//
//  RemindCell.m
//  ArtisticAucation
//
//  Created by Haley on 15/10/14.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "RemindCell.h"

@implementation RemindCell

- (void)awakeFromNib {
    // Initialization code
    UIImage *image = [[UIImage imageNamed:@"red_button_nor"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.deleteBut setBackgroundImage:image forState:UIControlStateNormal];
    UIImage *simage = [[UIImage imageNamed:@"red_button_sel"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.deleteBut setBackgroundImage:simage forState:UIControlStateHighlighted];
    
    self.headIV.layer.masksToBounds = YES;
    self.headIV.layer.cornerRadius = AucationItemCornerRadius;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)actionDelete
{
    if(self.myRemindBlock)
    {
        self.myRemindBlock();
    }
}

@end
