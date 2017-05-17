//
//  AucationItemImagesScrollView.h
//  ArtisticAucation
//
//  Created by xieran on 15/11/17.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAImagesScrollView : UIView

@property(nonatomic,retain)NSArray *imageUrls;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger currentIndex;

@property(nonatomic,copy)void(^tapBlock)(NSArray *imgUrls,NSInteger currentIndex,id dataModel);

-(void)setTapBlock:(void (^)(NSArray *imgUrls, NSInteger currentIndex, id dataModel))tapBlock;

@end
