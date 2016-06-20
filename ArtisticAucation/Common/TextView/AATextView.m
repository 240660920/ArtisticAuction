//
//  AATextView.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/12.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AATextView.h"

@interface AATextView ()

@property(nonatomic,assign)SEL textChangeAction;
@property(nonatomic,strong)UILabel *placeHolderLabel;

@end

@implementation AATextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

-(id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

-(void)addTarget:(id)target action:(nonnull SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

-(void)textDidChange:(NSNotification *)notice
{
    if (self.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
    }
    else{
        self.placeHolderLabel.hidden = YES;
    }
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeHolderLabel.font = font;
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    self.placeHolderLabel.text = placeholder;
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    
    if (text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    }
}

-(UILabel *)placeHolderLabel
{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc]init];
        _placeHolderLabel.textColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
        [self addSubview:_placeHolderLabel];
        
        [_placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(7);
            make.left.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
        }];
    }
    return _placeHolderLabel;
}

@end
