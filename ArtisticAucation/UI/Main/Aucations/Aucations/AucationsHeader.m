//
//  AucationsHeaader.m
//  ArtisticAucation
//
//  Created by Haley on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationsHeader.h"

#define SegmentHeight 38
#define ADImageRatio 9.0/16.0

@interface AucationsHeader ()

@end

@implementation AucationsHeader

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    self.segmentControl = [[SegmentControl alloc]initWithNormalImages:nil selectedImages:nil titles:@[@"预展中",@"拍卖中"] frame:CGRectMake(0,180,Screen_Width,SegmentHeight) delegate:self.delegate];

    self.segmentControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:self.self.segmentControl];
    
    
    
    self.scrollView.frame = CGRectMake(0, 0, Screen_Width, 9.0/16.0 * Screen_Width);
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation"]];
    
    self.frame = CGRectMake(0, 0, Screen_Width, Screen_Width * ADImageRatio + SegmentHeight);
}

-(void)setDelegate:(id)delegate
{
    _delegate = delegate;
    
    self.segmentControl.delegate = delegate;
}

-(void)setSegmentSelectedIndex:(NSInteger )index
{
    [self.segmentControl setSelectedIndex:index];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
