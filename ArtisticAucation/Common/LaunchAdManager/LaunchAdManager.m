//
//  LaunchAdManager.m
//  ArtisticAuction
//
//  Created by xieran on 16/8/23.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import "LaunchAdManager.h"
#import "LaunchAdResponse.h"
#import "LaunchAdArchieveModule.h"
#import "HttpManager.h"
#import <SDWebImage/SDWebImageDownloader.h>

#define LaunchAdArchievePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/LaunchAd"]

@implementation LaunchAdManager

+(void)showIfNeeded
{
    LaunchAdArchieveModule *module = [NSKeyedUnarchiver unarchiveObjectWithFile:LaunchAdArchievePath];
    BOOL shouldShow = NO;
    NSString *imgUrl = nil;
    if (iPhone5Screen) {
        shouldShow = module.img_4inch.length > 0;
        imgUrl = module.img_4inch;
    }
    else if (iPhone6Screen){
        shouldShow = module.img_47inch.length > 0;
        imgUrl = module.img_47inch;
    }
    else if (iPhone6PlusScreen){
        shouldShow = module.img_55inch.length > 0;
        imgUrl = module.img_55inch;
    }
    
    if (shouldShow) {
        
        UIView *background = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
        background.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:background];

        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = background.bounds;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[imgUrl completeImageUrlString]]];
        [background addSubview:imageView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                background.alpha = 0;
            } completion:^(BOOL finished) {
                [background removeFromSuperview];
            }];
        });
    }
}

+(void)requestAd
{
    [HttpManager requestWithAPI:@"user/getHomePagePic" params:nil requestMethod:@"GET" completion:^(ASIFormDataRequest *request) {
        
        LaunchAdResponse *response = [[LaunchAdResponse alloc]initWithString:request.responseString error:nil];
        if (response && response.result.resultCode.intValue == 0) {
            LaunchAdArchieveModule *module = [[LaunchAdArchieveModule alloc]init];
            module.img_4inch = response.data.img_4inch;
            module.img_47inch = response.data.img_47inch;
            module.img_55inch = response.data.img_55inch;
            
            
            LaunchAdArchieveModule *localModule = [NSKeyedUnarchiver unarchiveObjectWithFile:LaunchAdArchievePath];
            if (iPhone5Screen) {
                if (![module.img_4inch isEqualToString:localModule.img_4inch]) {
                    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:[module.img_4inch completeImageUrlString]] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        
                    }];
                }
            }
            else if (iPhone6Screen){
                if (![module.img_47inch isEqualToString:localModule.img_47inch]) {
                    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:[module.img_47inch completeImageUrlString]] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        
                    }];
                }
            }
            else if (iPhone6PlusScreen){
                if (![module.img_55inch isEqualToString:localModule.img_55inch]) {
                    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:[module.img_55inch completeImageUrlString]] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                        
                    }];
                }
            }
            
            
            [NSKeyedArchiver archiveRootObject:module toFile:LaunchAdArchievePath];
        }
        
    } failed:^(ASIFormDataRequest *request) {
        
    }];
}

@end
