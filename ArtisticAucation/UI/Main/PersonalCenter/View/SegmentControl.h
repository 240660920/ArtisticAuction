//
//  SegmentControl.h
//  ArtisticAucation
//
//  Created by xieran on 15/9/18.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentControlDelegate <NSObject>

-(void)didSelectSegmentAtIndex:(NSInteger )index;

@end

@interface SegmentControl : UIView

@property(nonatomic,weak)id<SegmentControlDelegate>delegate;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,assign)BOOL separatorLineHidden;

-(id)initWithNormalImages:(NSArray *)normalImages selectedImages:(NSArray *)selectedImages titles:(NSArray *)titles frame:(CGRect )frame delegate:(id<SegmentControlDelegate>)delegate;

-(void)beginSwitchAnimation;

@end
