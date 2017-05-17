//
//  AuctionHallStateView.m
//  ArtisticAuction
//
//  Created by xieran on 2017/4/25.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallStateView.h"

@implementation AuctionHallStateView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    UILabel *line = [[UILabel alloc]init];
    line.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (IBAction)itemList:(id)sender {
    self.tapItemListBlock();
}
@end
