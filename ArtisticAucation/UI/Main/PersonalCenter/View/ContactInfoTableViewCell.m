//
//  ContactInfoTableViewCell.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/28.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "ContactInfoTableViewCell.h"

@interface ContactInfoTableViewCell ()

@end

@implementation ContactInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = BlackColor;
        _nameLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.width.equalTo(@80);
            make.top.equalTo(self.contentView);
            make.height.equalTo(self.contentView).multipliedBy(0.5);
        }];
    }
    return _nameLabel;
}

-(UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.textColor = BlackColor;
        _addressLabel.font = [UIFont systemFontOfSize:12];
        _addressLabel.numberOfLines = 2;
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_addressLabel];
        
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.width.equalTo(self.contentView).offset(-30);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.height.equalTo(self.contentView).multipliedBy(0.5);
        }];
    }
    return _addressLabel;
}

-(UILabel *)phoneNumLabel
{
    if (!_phoneNumLabel) {
        _phoneNumLabel = [[UILabel alloc]init];
        _phoneNumLabel.textColor = BlackColor;
        _phoneNumLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:_phoneNumLabel];
        
        [_phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.height.centerY.equalTo(self.nameLabel);
        }];
    }
    return _phoneNumLabel;
}

@end
