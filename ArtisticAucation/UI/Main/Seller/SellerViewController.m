//
//  SellerViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/11.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "SellerViewController.h"
#import "RealNameCerViewController.h"
#import "UploadListViewController.h"
#import "OpenupSessionViewController.h"
#import "UIAlertView+TapBlock.h"
#import "SubmitPerformanceNameController.h"
#import "UploadItemViewController.h"
#import <objc/runtime.h>

@interface SellerViewController ()<UIAlertViewDelegate>

@end

@implementation SellerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"送拍";
    self.navigationItem.leftBarButtonItems = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)actionTap:(UIButton *)sender
{
    if ([UserInfo sharedInstance].loginType == kLoginTypeTraveller || [UserInfo sharedInstance].loginType == kLoginTypeWeixin) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请使用手机号登录" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        [alert handleClickedButton:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        return;
    }
    
    
    NSInteger idCertifyState = [UserInfo sharedInstance].identifyCertifyState;
    switch (idCertifyState) {
        case IdentityCheckStateNotCheck:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"开设专场或上传拍品前需要进行实名认证" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去认证", nil];
            [alert show];
            [alert handleClickedButton:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    RealNameCerViewController *realViewController = [[RealNameCerViewController alloc] init];
                    [self.navigationController pushViewController:realViewController animated:YES];
                    
                }
            }];
        }
            break;
        case IdentityCheckStateFinished:{
            if (sender.tag == 1) {
                if([UserInfo sharedInstance].agencyName.length == 0){
                    SubmitPerformanceNameController *vc = [[SubmitPerformanceNameController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else{
                    OpenupSessionViewController *vc = [[OpenupSessionViewController alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            else{
                //单件送拍
                UploadItemViewController *vc = objc_getAssociatedObject([UIApplication sharedApplication].delegate, "UploadItemViewController");
                if (!vc) {
                    vc = [[UploadItemViewController alloc]init];
                    objc_setAssociatedObject([UIApplication sharedApplication].delegate, "UploadItemViewController", vc, OBJC_ASSOCIATION_RETAIN);
                }
                else{
                    [vc.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case IdentityCheckStateFailed:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您上次提交的实名认证信息未通过" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新认证", nil];
            [alert show];
            [alert handleClickedButton:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    RealNameCerViewController *realViewController = [[RealNameCerViewController alloc] init];
                    [self.navigationController pushViewController:realViewController animated:YES];
                    
                }
            }];
        }
            break;
        case IdentifyCheckStateOnChecking:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您上次提交的实名认证信息正在审核中,请重新登录后再试" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
