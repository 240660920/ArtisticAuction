//
//  MyCollectionsViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/16.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "MyFavoritesViewController.h"
#import "SegmentControl.h"
#import "LotsInFavoritesController.h"
#import "AgencyInFavoritesController.h"
#import "SpecialPerformanceInFavoritesController.h"

@interface MyFavoritesViewController ()<SegmentControlDelegate>

@property(nonatomic,strong)SegmentControl *segmentControl;

@property(nonatomic,strong)LotsInFavoritesController *lotsViewController;
@property(nonatomic,strong)AgencyInFavoritesController *agencyViewController;
@property(nonatomic,strong)SpecialPerformanceInFavoritesController *aucationsViewController;

@end

@implementation MyFavoritesViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.segmentControl.hidden = NO;
    
    [self.lotsViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentControl.mas_bottom).offset(-0.5);
    }];
    
    [self.agencyViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentControl.mas_bottom).offset(-0.5);
    }];
    
    [self.aucationsViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.segmentControl.mas_bottom).offset(-0.5);
    }];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma Delegates
-(void)didSelectSegmentAtIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            [self.view bringSubviewToFront:self.lotsViewController.view];
            break;
        case 1:
            [self.view bringSubviewToFront:self.agencyViewController.view];
            break;
        case 2:
            [self.view bringSubviewToFront:self.aucationsViewController.view];
            break;
        default:
            break;
    }
    [self.view bringSubviewToFront:self.segmentControl];
}

#pragma mark Private Methods


#pragma mark Properties
-(SegmentControl *)segmentControl
{
    if (!_segmentControl) {
        NSArray *normalImages = @[];
        NSArray *selImages = @[];
        NSArray *titles = @[@"拍品",@"机构",@"专场"];
        
        _segmentControl = [[SegmentControl alloc]initWithNormalImages:normalImages
                                                       selectedImages:selImages
                                                               titles:titles
                                                                frame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 36)
                                                             delegate:self];
        _segmentControl.delegate = self;
        [self.view addSubview:_segmentControl];
    }
    return _segmentControl;
}

-(LotsInFavoritesController *)lotsViewController
{
    if (!_lotsViewController) {
        _lotsViewController = [[LotsInFavoritesController alloc]init];
        [self addChildViewController:_lotsViewController];
        [self.view insertSubview:_lotsViewController.view belowSubview:self.segmentControl];
    }
    return _lotsViewController;
}

-(AgencyInFavoritesController *)agencyViewController
{
    if (!_agencyViewController) {
        _agencyViewController = [[AgencyInFavoritesController alloc]init];
        [self addChildViewController:_agencyViewController];
        [self.view insertSubview:_agencyViewController.view belowSubview:self.lotsViewController.view];
    }
    return _agencyViewController;
}

-(SpecialPerformanceInFavoritesController *)aucationsViewController
{
    if (!_aucationsViewController) {
        _aucationsViewController = [[SpecialPerformanceInFavoritesController alloc]init];
        [self addChildViewController:_aucationsViewController];
        [self.view insertSubview:_aucationsViewController.view belowSubview:self.lotsViewController.view];
    }
    return _aucationsViewController;
}

@end
