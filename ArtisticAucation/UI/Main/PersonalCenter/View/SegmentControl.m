//
//  SegmentControl.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/18.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "SegmentControl.h"

@interface SegmentControl ()

@property(nonatomic,retain)NSMutableArray *buttonsArray;
@property(nonatomic,retain)CALayer *redLayer;
@property(nonatomic,retain)UIImageView *line;

@end

@implementation SegmentControl

-(id)initWithNormalImages:(NSArray *)normalImages
           selectedImages:(NSArray *)selectedImages
                   titles:(NSArray *)titles
                    frame:(CGRect)frame
                 delegate:(id<SegmentControlDelegate>)delegate
{
    if (self = [super initWithFrame:frame]) {
        UIView *background = [[UIView alloc]init];
        background.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"navigation"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
        background.layer.masksToBounds = YES;
        background.frame = self.bounds;
        [self insertSubview:background atIndex:0];
        
        
        self.line = [[UIImageView alloc]init];
        self.line.backgroundColor = TableViewSeparateColor;
        self.line.frame = CGRectMake(0, frame.size.height - 0.5, frame.size.width, 0.5);
        self.line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.line];
        
        
        self.delegate = delegate;
        self.userInteractionEnabled = YES;
        NSMutableArray *buttonsArray = [[NSMutableArray alloc]init];

        NSInteger count = normalImages.count == 0 ? titles.count : normalImages.count;
        for (int i = 0; i < count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.frame = CGRectMake(frame.size.width / count * i, 0, frame.size.width / count, frame.size.height);
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1] forState:UIControlStateNormal];
            if (normalImages.count > 0 && normalImages[i]) {
                [button setImage:normalImages[i] forState:UIControlStateNormal];
            }
            if (selectedImages.count > 0 && selectedImages[i]) {
                [button setImage:selectedImages[i] forState:UIControlStateSelected];
            }
            if (titles.count > 0 && titles[i]) {
                [button setTitle:titles[i] forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [buttonsArray addObject:button];
            
            [self addSubview:button];
        }
        self.buttonsArray = buttonsArray;
        [self.buttonsArray[0] setSelected:YES];
        [self.layer addSublayer:self.redLayer];
        [self setNeedsDisplay];
    }
    return self;
}

-(void)setSeparatorLineHidden:(BOOL)separatorLineHidden
{
    _separatorLineHidden = separatorLineHidden;
    
    if (separatorLineHidden) {
        self.line.hidden = YES;
    }
}

-(void)buttonClicked:(UIButton *)sender
{
    for (UIButton *button in self.buttonsArray) {
        if (button.tag == sender.tag) {
            button.selected = YES;
            
            self.selectedIndex = sender.tag;
        }
        else{
            button.selected = NO;
        }
    }
    
    [self beginSwitchAnimation];
    
    [self setNeedsDisplay];
}

-(void)setSelectedIndex:(NSInteger)index
{
    if (_selectedIndex != index) {
        _selectedIndex = index;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectSegmentAtIndex:)]) {
            [self.delegate didSelectSegmentAtIndex:index];
            
            [self buttonClicked:self.buttonsArray[index]];
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void)beginSwitchAnimation
{
    [self.buttonsArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        if (button.selected) {
            CGFloat originX = button.frame.origin.x + button.frame.size.width / 2 - 30;
            self.redLayer.frame = CGRectMake(originX, self.bounds.size.height - 3, 60, 3);
        }
    }];
}

-(CALayer *)redLayer
{
    if (!_redLayer) {
        _redLayer = [CALayer layer];
        _redLayer.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:15.0/255.0 blue:38.0/255.0 alpha:1].CGColor;
        CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width / self.buttonsArray.count;
        _redLayer.frame = CGRectMake((buttonWidth - 60) / 2, self.bounds.size.height - 3 , 60, 3);
    }
    return _redLayer;
}

@end
