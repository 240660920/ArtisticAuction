//
//  QuickPricePickerView.m
//  Area
//
//  Created by xieran on 16/1/28.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import "QuickPricePickerView.h"

@interface QuickPricePickerView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation QuickPricePickerView

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"bid_table"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 44;
        self.scrollEnabled = NO;
        self.separatorColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.currentIndex = 0;
    }
    return self;
}

-(void)dismiss
{
    [UIView beginAnimations:nil context:nil];
    self.alpha = 0;
    [UIView commitAnimations];
}

-(void)setPriceArray:(NSArray *)priceArray
{
    _priceArray = priceArray;
    
    [self reloadData];
    
    for (int i = 1; i < priceArray.count; i++) {
        UILabel *line = [[UILabel alloc]init];
        line.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        line.frame = CGRectMake(2, i * 44, 190, 0.5);
        [self addSubview:line];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.priceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"QuickPricePickerView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundView = [[UIView alloc]init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    

    
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (self.currentIndex == indexPath.row) {
        UIImageView *hook = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hook"]];
        hook.frame = CGRectMake(130, 10.5, 23, 23);
        [cell.contentView addSubview:hook];
    }

    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(65, 0, 100, 44)];
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor colorWithRed:0x51/255.0 green:0x51/255.0 blue:0x51/255.0 alpha:1];
    label.text = [NSString stringWithFormat:@"¥ %@",self.priceArray[indexPath.row]];
    [cell.contentView addSubview:label];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.currentIndex = indexPath.row;
    
    [self reloadData];
    
    if (self.selectPriceBlock) {
        self.selectPriceBlock(indexPath.row);
    }
    
    [UIView beginAnimations:nil context:nil];
    self.alpha = 0;
    [UIView commitAnimations];
}

@end
