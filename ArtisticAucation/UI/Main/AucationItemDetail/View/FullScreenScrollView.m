//
//  FullScreenScrollView.m
//  ArtisticAucation
//
//  Created by xieran on 15/12/7.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "FullScreenScrollView.h"

@interface FullScreenScrollView ()<UIScrollViewDelegate>

@property(nonatomic,retain)NSMutableArray *imageViews;

@end

@implementation FullScreenScrollView

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
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
    self.backgroundColor = [UIColor blackColor];
    self.bounces = NO;
    self.pagingEnabled = YES;
    self.delegate = self;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)]];
    
    _imageViews = [[NSMutableArray alloc]init];
}

-(void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    
    [self.imageViews removeAllObjects];
    
    self.contentSize = CGSizeMake(Screen_Width * imageUrls.count, 0);
    
    
    for (int i = 0; i < imageUrls.count; i++) {
        UIScrollView *subScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(i * Screen_Width, 0, Screen_Width, Screen_Height)];
        subScrollView.delegate = self;
        subScrollView.maximumZoomScale = 2.0;
        [self addSubview:subScrollView];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        imageView.backgroundColor = [UIColor blackColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [subScrollView addSubview:imageView];
        [self.imageViews addObject:imageView];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:imageView animated:NO];
        hud.mode = MBProgressHUDModeDeterminate;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:[imageUrls[i] completeImageUrlString]] placeholderImage:nil options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            if (receivedSize > 0) {
                float progress = (float)receivedSize / (float)expectedSize;
                hud.progress = progress;
            }
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [imageView setImage:image];
            [hud hide:NO];
        }];
    }
}

-(void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
}

-(void)show
{
    self.contentOffset = CGPointMake(self.currentIndex * Screen_Width, 0);
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
}

-(void)dismiss
{
    [self removeFromSuperview];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self) {
        int contentOffset = scrollView.contentOffset.x;
        int width = Screen_Width;
        if (contentOffset % width == 0) {
            int newPageIndex = contentOffset / width;
            
            if (newPageIndex != self.currentIndex) {
                for (UIScrollView *sc in self.subviews) {
                    if ([sc isKindOfClass:[UIScrollView class]]) {
                        sc.zoomScale = 1.0;
                    }
                }
            }
            
            self.currentIndex = newPageIndex;
            
            
        }
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageViews[self.currentIndex];
}

@end
