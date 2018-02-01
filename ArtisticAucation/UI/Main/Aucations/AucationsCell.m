//
//  AucationsCell.m
//  ArtisticAucation
//
//  Created by Haley on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationsCell.h"
#import "FMUString.h"
#import "Remind.h"

@interface AucationsCell ()

@end

@implementation AucationsCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.backImageV.layer.masksToBounds = YES;
    self.backImageV.layer.cornerRadius = AucationItemCornerRadius;
    
    
    UILabel *bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(0, [[self class] heightForRow] - 1 / [UIScreen mainScreen].scale, Screen_Width, 1 / [UIScreen mainScreen].scale)];
    bottomLine.backgroundColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:155.0/255.0 alpha:1];
    [self addSubview:bottomLine];
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    self.backImageV.frame = CGRectMake(20, -0.5, Screen_Width - 40, [[self class]heightForImageView]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setStartTime:(NSString *)startTime
{
    _startTime = startTime;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@开始",[startTime substringToIndex:startTime.length - 3]];
}

-(void)setStatus:(DisplayState)status
{
    _status = status;
    
    switch (status) {
        case DisplayTypePreDisplay:
            self.remindBtn.hidden = NO;
            self.goAuction.hidden = YES;
//            self.goAuction.hidden = NO;
            self.onGoingLabel.hidden = YES;
            self.timeLabel.hidden = NO;
            break;
        case DisplayTypeOngoing:
            self.remindBtn.hidden = YES;
            self.goAuction.hidden = NO;
            self.onGoingLabel.hidden = NO;
            self.timeLabel.hidden = YES;
            self.onGoingLabel.hidden = NO;
            self.onGoingLabel.text = @"正在拍卖中";
            break;
        case DisplayTypeEnded:
            self.remindBtn.hidden = YES;
            self.goAuction.hidden = YES;
            self.onGoingLabel.hidden = YES;
            self.timeLabel.hidden = YES;
            self.onGoingLabel.hidden = NO;
            self.onGoingLabel.text = @"已结束";
            break;
        default:
            self.remindBtn.hidden = YES;
            self.goAuction.hidden = YES;
            self.onGoingLabel.hidden = YES;
            self.timeLabel.hidden = YES;
            self.onGoingLabel.hidden = NO;
            self.onGoingLabel.text = @"未开始";
            break;
    }
}

-(IBAction)actionTapSign:(id)sender
{
    self.pushBlock();
}

-(IBAction)actionTapAucation:(id)sender
{
    if(self.hallBlock)
    {
        self.hallBlock();
    }
}

- (IBAction)likeBtnClicked:(id)sender {
    self.likeRequestBlock();
}

- (IBAction)collectBtnClicked:(id)sender {
    self.collectRequestBlock();
}

+(CGFloat)heightForImageView
{
    CGFloat imageWidth = Screen_Width - 40;
    CGFloat imageHeight = imageWidth / 2;
    return imageHeight;
}

+(CGFloat)heightForRow
{
    return [self heightForImageView] + 106;
}

@end
