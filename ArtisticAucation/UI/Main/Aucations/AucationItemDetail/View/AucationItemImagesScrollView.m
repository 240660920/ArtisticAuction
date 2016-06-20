//
//  AucationItemImagesScrollView.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/17.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationItemImagesScrollView.h"

@interface AucationItemImagesScrollView()<UIScrollViewDelegate>
{

}


@end

@implementation AucationItemImagesScrollView

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

-(void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    
    self.currentIndex = 0;
    
    if (self.timer) {
        [self.timer invalidate];
    }
    if (imageUrls.count > 1) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(autoCycle) userInfo:nil repeats:YES];
    }
    
    
    for (UIImageView *imageView in self.subviews) {
        if ([imageView isMemberOfClass:[UIImageView class]]) {
            [imageView removeFromSuperview];
        }
    }

    
    if (imageUrls.count <= 1) {
        self.scrollView.contentSize = CGSizeZero;
    }
    else{
        self.scrollView.contentSize = CGSizeMake(Screen_Width * (imageUrls.count + 2), 0);
        
        //第一页左边放最后一页
        UIImageView *leftImageView = [[UIImageView alloc]init];
        leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [leftImageView sd_setImageWithURL:[NSURL URLWithString:[[imageUrls lastObject] completeImageUrlString]] placeholderImage:nil];
        [self.scrollView addSubview:leftImageView];
        
        //最后一页右边再放第一页
        UIImageView *rightImgeView = [[UIImageView alloc]init];
        rightImgeView.contentMode = UIViewContentModeScaleAspectFit;
        [rightImgeView sd_setImageWithURL:[NSURL URLWithString:[imageUrls[0] completeImageUrlString]] placeholderImage:nil];
        [self.scrollView addSubview:rightImgeView];
        
        
        
        [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@(0));
            make.width.equalTo(@(Screen_Width));
            make.height.equalTo(self.scrollView);
        }];
        
        [rightImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@((imageUrls.count + 1) * Screen_Width));
            make.top.equalTo(self.scrollView);
            make.width.equalTo(@(Screen_Width));
            make.height.equalTo(self.scrollView);
        }];
        
        [self.scrollView setContentOffset:CGPointMake(Screen_Width, 0)];
    }
    
    

    
    for (int i = 0; i < imageUrls.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[imageUrls[i] completeImageUrlString]] placeholderImage:nil];
        [self.scrollView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(Screen_Width * (imageUrls.count > 1 ? (i+1) : 0)));
            make.width.equalTo(self);
            make.height.equalTo(self);
            make.top.equalTo(self);
        }];
    }
    
    
    self.pageControl.numberOfPages = imageUrls.count;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffset = scrollView.contentOffset.x;
    int width = Screen_Width;
    if (contentOffset % width == 0) {
        int pageIndex = contentOffset / width - 1;
        if (pageIndex == -1) {
            pageIndex = (int)self.imageUrls.count - 1;
            
            [scrollView setContentOffset:CGPointMake(Screen_Width * self.imageUrls.count, 0) animated:NO];
        }
        else if (pageIndex == self.imageUrls.count){
            pageIndex = 0;
            
            [scrollView setContentOffset:CGPointMake(Screen_Width * 1, 0) animated:NO];
        }
        
        self.pageControl.currentPage = pageIndex;
        self.currentIndex = pageIndex;
    }
}

#pragma mark Private 
-(void)tap
{
    self.fullScreenScrollView = [[FullScreenScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    self.fullScreenScrollView.imageUrls = self.imageUrls;
    self.fullScreenScrollView.currentIndex = self.currentIndex;
    [self.fullScreenScrollView show];
}

-(void)autoCycle
{
    self.currentIndex++;

    [self.scrollView setContentOffset:CGPointMake((self.currentIndex + 1) * self.frame.size.width, 0) animated:YES];
}


#pragma mark Properties
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)]];
        [self addSubview:_scrollView];
        
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _scrollView;
}

-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        [self insertSubview:_pageControl aboveSubview:_scrollView];
        
        
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.equalTo(@10);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    return _pageControl;
}

@end
