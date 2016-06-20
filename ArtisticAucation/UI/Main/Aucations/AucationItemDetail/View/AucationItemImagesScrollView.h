//
//  AucationItemImagesScrollView.h
//  ArtisticAucation
//
//  Created by xieran on 15/11/17.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullScreenScrollView.h"

@interface AucationItemImagesScrollView : UIView

@property(nonatomic,retain)NSArray *imageUrls;
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)FullScreenScrollView *fullScreenScrollView;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)NSInteger currentIndex;

@end
