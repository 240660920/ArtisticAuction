//
//  AucationDetailMoreView.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationItemDescriptionCell.h"

#define AucationItemDescFont [UIFont systemFontOfSize:14]

@interface AucationItemDescriptionCell ()


@end

@implementation AucationItemDescriptionCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(CGFloat)heightForText:(NSString *)text
{    
    CGFloat titleHeight = [@"123" boundingRectWithSize:CGSizeMake(Screen_Width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : AucationItemDescFont} context:nil].size.height;
    
    if (text.length == 0) {
        text = @"暂无";
    }
    
    return [text boundingRectWithSize:CGSizeMake(Screen_Width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : AucationItemDescFont} context:nil].size.height + titleHeight + 10 + 5 + 10;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titlelabel);
        make.width.equalTo(@(Screen_Width - 30));
        make.top.equalTo(self.titlelabel.mas_bottom).offset(5);
    }];
}

-(UILabel *)titlelabel
{
    if (!_titlelabel) {
        _titlelabel = [[UILabel alloc]init];
        _titlelabel.font = AucationItemDescFont;
        _titlelabel.textColor = BlackColor;
        [self.contentView addSubview:_titlelabel];
    }
    return _titlelabel;
}

-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = AucationItemDescFont;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

@end
