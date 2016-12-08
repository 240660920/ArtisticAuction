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
    NSString *imgUrl = nil;
    if (iPhone5Screen) {
        imgUrl = module.img_4inch;
    }
    else if (iPhone6Screen){
        imgUrl = module.img_47inch;
    }
    else if (iPhone6PlusScreen){
        imgUrl = module.img_55inch;
    }
    
    
    
    BOOL shouldShow = imgUrl.length > 0 ? YES : NO;
    
    
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

+(void)requestLaunchAdImage
{
    [HttpManager requestWithAPI:@"user/getHomePagePic" params:nil requestMethod:@"GET" completion:^(ASIFormDataRequest *request) {
        
        LaunchAdResponse *response = [[LaunchAdResponse alloc]initWithString:request.responseString error:nil];
        if (response && response.result.resultCode.intValue == 0) {
            LaunchAdArchieveModule *module = [[LaunchAdArchieveModule alloc]init];
            module.img_4inch = response.data.img_4inch;
            module.img_47inch = response.data.img_47inch;
            module.img_55inch = response.data.img_55inch;
            
            
            NSString *propertyName;
            if (iPhone5Screen) {
                propertyName = @"img_4inch";
            }
            else if (iPhone6Screen){
                propertyName = @"img_47inch";
            }
            else if (iPhone6PlusScreen){
                propertyName = @"img_55inch";
            }
            
            

            LaunchAdArchieveModule *localModule = [NSKeyedUnarchiver unarchiveObjectWithFile:LaunchAdArchievePath];
            
            
            if (![[module valueForKey:propertyName] isEqualToString:[localModule valueForKey:propertyName]]) {
                [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:[[module valueForKey:propertyName] completeImageUrlString]] options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    if (image) {
                        [NSKeyedArchiver archiveRootObject:module toFile:LaunchAdArchievePath];
                    }
                    else{
                        [[NSFileManager defaultManager]removeItemAtPath:LaunchAdArchievePath error:nil];
                    }
                }];
            }
        }
        else{
            [[NSFileManager defaultManager]removeItemAtPath:LaunchAdArchievePath error:nil];
        }
        
        
    } failed:^(ASIFormDataRequest *request) {
        
    }];
}

@end
