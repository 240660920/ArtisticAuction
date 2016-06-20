//
//  MyAucationsViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/16.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "MyLotsViewController.h"
#import "SegmentControl.h"
#import "NotPaidLotsViewController.h"
#import "PaidLotsViewController.h"
#import "BiddenLotsViewController.h"
#import "MyLotsCell.h"

@interface MyLotsViewController ()<SegmentControlDelegate>

@property(nonatomic,retain)SegmentControl *segmentControl;
@property(nonatomic,retain)NotPaidLotsViewController *notPaidViewControleller;
@property(nonatomic,retain)PaidLotsViewController    *paidLotsViewController;
@property(nonatomic,retain)BiddenLotsViewController  *biddenLotsViewController;

@end

@implementation MyLotsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的拍品";
    
    if ([UserInfo sharedInstance].loginType == kLoginTypeTraveller || [UserInfo sharedInstance].loginType == kLoginTypeWeixin) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请使用手机号登录后查询" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert handleClickedButton:^(NSInteger buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.biddenLotsViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentControl.mas_bottom);
    }];
    
    [self.paidLotsViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentControl.mas_bottom);
    }];
    
    [self.notPaidViewControleller.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentControl.mas_bottom);
    }];
}

#pragma delegates
-(void)didSelectSegmentAtIndex:(NSInteger)index
{
    if (index == 0) {
        [self.view bringSubviewToFront:self.notPaidViewControleller.view];
    }
    else if (index == 1){
        [self.view bringSubviewToFront:self.paidLotsViewController.view];
    }
    else{
        [self.view bringSubviewToFront:self.biddenLotsViewController.view];
    }
}

#pragma properties
-(SegmentControl *)segmentControl
{
    if (!_segmentControl) {
        _segmentControl = [[SegmentControl alloc]initWithNormalImages:nil selectedImages:nil titles:@[@"未付款",@"已付款",@"参拍记录"] frame:CGRectMake(0, 0, Screen_Width, 36) delegate:self];
        [self.view addSubview:_segmentControl];
    }
    return _segmentControl;
}

-(NotPaidLotsViewController *)notPaidViewControleller
{
    if (!_notPaidViewControleller) {
        _notPaidViewControleller = [[NotPaidLotsViewController alloc]init];
        [self addChildViewController:_notPaidViewControleller];
        [self.view addSubview:_notPaidViewControleller.view];
    }
    return _notPaidViewControleller;
}

-(PaidLotsViewController *)paidLotsViewController
{
    if (!_paidLotsViewController) {
        _paidLotsViewController = [[PaidLotsViewController alloc]init];
        [self addChildViewController:_paidLotsViewController];
        [self.view addSubview:_paidLotsViewController.view];
    }
    return _paidLotsViewController;
}

-(BiddenLotsViewController *)biddenLotsViewController
{
    if (!_biddenLotsViewController) {
        _biddenLotsViewController = [[BiddenLotsViewController alloc]init];
        [self addChildViewController:_biddenLotsViewController];
        [self.view addSubview:_biddenLotsViewController.view];
    }
    return _biddenLotsViewController;
}

@end
