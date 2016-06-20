//
//  UIViewController+LoginAlert.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/23.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "UIViewController+LoginAlert.h"

@implementation UIViewController (LoginAlert)

-(void)showLoginAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请先登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert handleClickedButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self.tabBarController.navigationController popViewControllerAnimated:YES];
        }
    }];
    [alert show];
}

@end
