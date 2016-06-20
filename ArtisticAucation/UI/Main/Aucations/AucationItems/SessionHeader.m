//
//  SessionHeader.m
//  ArtisticAucation
//
//  Created by Haley on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "SessionHeader.h"

@implementation SessionHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"navigation"] stretchableImageWithLeftCapWidth:5 topCapHeight:0]];

}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageWidth = Screen_Width;
    CGFloat imageHeight = 140;
    if (self.backImageV.image) {
        imageHeight = imageWidth * self.backImageV.image.size.height / self.backImageV.image.size.width;
    }
    self.backImageV.frame = CGRectMake(0, 0, imageWidth, imageHeight);
    
    CGRect frame = self.frame;
    frame.size.height = CGRectGetHeight(self.backImageV.frame) + 67;
    self.frame = frame;
}


-(IBAction)actionTap:(UIButton *)sender
{
    if(self.remindBlock)
    {
        self.remindBlock();
    }
}

- (IBAction)likeBtnClicked:(id)sender {
    self.likeBlock(sender);
}

- (IBAction)collectBtnClicked:(id)sender {
    self.collectBlock(sender);
}

-(void)setStatus:(DisplayState)displayStatus
{
    self.statusLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    self.statusLabel.textColor = BlackColor;
    
    switch (displayStatus) {
        case DisplayTypePreDisplay:
            self.statusLabel.text = @"预展中";
            self.statusLabel.textColor = [UIColor whiteColor];
            self.statusLabel.backgroundColor = [UIColor colorWithRed:1 green:106.0/255.0 blue:0 alpha:0.8];
            break;
        case DisplayTypeOngoing:
            self.statusLabel.text = @"进行中";
            break;
        case DisplayTypeEnded:
            self.statusLabel.text = @"已结束";
            break;
        default:
            break;
    }
}

@end
