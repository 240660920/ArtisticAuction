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
    
    [super awakeFromNib];
    
    UIImage *image = [[UIImage imageNamed:@"red_button_nor"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.deleteBut setBackgroundImage:image forState:UIControlStateNormal];
    UIImage *simage = [[UIImage imageNamed:@"red_button_sel"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.deleteBut setBackgroundImage:simage forState:UIControlStateHighlighted];
        
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    
    
    for (int i = 0; i < 2; i++) {
        UILabel *line = [[UILabel alloc]init];
        line.frame = CGRectMake(0, i * 197, Screen_Width, 1 / [UIScreen mainScreen].scale);
        line.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        [self.contentView addSubview:line];
    }
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
