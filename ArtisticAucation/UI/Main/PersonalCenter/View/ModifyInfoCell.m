//
//  ModifyInfoCell.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/12.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "ModifyInfoCell.h"

#define MofiyInfoCellFont [UIFont systemFontOfSize:16]

@interface ModifyInfoCell ()

@end

@implementation ModifyInfoCell

-(void)dealloc
{
    [self.rightTextView removeObserver:self forKeyPath:@"text"];

    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.top.equalTo(self.contentView);
            make.width.equalTo(@60);
            make.height.equalTo(@45);
        }];
        
        [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel.mas_right).offset(3);
            make.top.height.equalTo(self.leftLabel);
        }];
        
        [self.rightTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLabel.mas_right);
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(self.contentView).offset(4);
            make.bottom.equalTo(self.contentView).offset(-4);
        }];
        
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

-(void)textDidChange
{
    self.placeHolderLabel.hidden = self.rightTextView.text.length != 0;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self.rightTextView && [keyPath isEqualToString:@"text"]) {
        self.placeHolderLabel.hidden = self.rightTextView.text.length != 0;
    }
}

-(void)setLabelText:(NSString *)labelText
{
    _labelText = labelText;
    self.leftLabel.text = labelText;
}

-(void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.placeHolderLabel.text = placeHolder;
}


-(UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]init];
        _leftLabel.font = MofiyInfoCellFont;
        _leftLabel.textColor = BlackColor;
        [self.contentView addSubview:_leftLabel];
    }
    return _leftLabel;
}

-(UILabel *)placeHolderLabel
{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc]init];
        _placeHolderLabel.textColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
        _placeHolderLabel.font = MofiyInfoCellFont;
        [self.contentView addSubview:_placeHolderLabel];
    }
    return _placeHolderLabel;
}

-(UITextView *)rightTextView
{
    if (!_rightTextView) {
        _rightTextView = [[UITextView alloc]init];
        _rightTextView.textColor = BlackColor;
        _rightTextView.font = MofiyInfoCellFont;
        _rightTextView.backgroundColor = [UIColor clearColor];
        _rightTextView.showsVerticalScrollIndicator = NO;
        _rightTextView.showsHorizontalScrollIndicator = NO;
        _rightTextView.scrollEnabled = NO;
        [_rightTextView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionInitial context:nil];
        [self.contentView addSubview:_rightTextView];
    }
    return _rightTextView;
}



@end
