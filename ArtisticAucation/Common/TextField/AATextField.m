//
//  AATextField.m
//  ArtisticAucation
//
//  Created by xieran on 15/12/8.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AATextField.h"

@implementation AATextField

-(void)awakeFromNib
{
    [self config];
}

-(id)init
{
    if (self = [super init]) {
        [self config];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}

-(void)config
{
    self.font = [UIFont systemFontOfSize:16];
    self.textColor = BlackColor;
    [self setValue:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
