//
//  UIView+MBProgress.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/6.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "UIView+MBProgress.h"

@implementation UIView (MBProgress)

-(void)showLoadingHud
{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
}

-(void)showLoadingHudWithText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = text;
}

-(void)showHud:(NSString *)hudString
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = hudString;
    hud.mode = MBProgressHUDModeText;
}

-(void)showHudAndAutoDismiss:(NSString *)hudString
{
    [self hideAllHud];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = hudString;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1.5];
}

-(void)hideAllHud
{
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[MBProgressHUD class]]) {
            [(MBProgressHUD *)v hide:NO];
        }
    }
}

@end
