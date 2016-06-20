//
//  MyLotsCell.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/16.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "MyLotsCell.h"

@implementation MyLotsCell

-(void)dealloc
{
    [self.titleLabel removeObserver:self forKeyPath:@"text"];
}

- (void)awakeFromNib {
    // Initialization code
    
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    [self.titleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"text"] && object == self.titleLabel) {
        CGRect rect = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.titleLabel.frame.size.width, 35) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil];
        CGRect titleLabelFrame = self.titleLabel.frame;
        titleLabelFrame.size.height = rect.size.height;
        self.titleLabel.frame = titleLabelFrame;
        
        CGRect closingLabelFrame = self.closingPriceLabel.frame;
        closingLabelFrame.origin.y = CGRectGetMaxY(titleLabelFrame) + 6;
        self.closingPriceLabel.frame = closingLabelFrame;
        
        CGRect commissionLabelFrame = self.commissionPriceLabel.frame;
        commissionLabelFrame.origin.y = CGRectGetMaxY(closingLabelFrame) + 6;
        self.commissionPriceLabel.frame = commissionLabelFrame;
    }
}

-(void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    
    self.checkbox.tag = tag;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, TableViewSeparateColor.CGColor);
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, 0, 30);
    CGContextAddLineToPoint(context, Screen_Width, 30);
    CGContextMoveToPoint(context, 0, CGRectGetMaxY(rect) - 33);
    CGContextAddLineToPoint(context, Screen_Width, CGRectGetMaxY(rect) - 33);
    CGContextStrokePath(context);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
