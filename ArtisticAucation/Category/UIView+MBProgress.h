//
//  UIView+MBProgress.h
//  ArtisticAucation
//
//  Created by xieran on 15/9/6.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MBProgress)

-(void)showLoadingHud;

-(void)showLoadingHudWithText:(NSString *)text;

-(void)showHud:(NSString *)hudString;

-(void)showHudAndAutoDismiss:(NSString *)hudString;

-(void)hideAllHud;

@end
