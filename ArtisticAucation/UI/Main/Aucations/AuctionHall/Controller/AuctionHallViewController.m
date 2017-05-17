//
//  AuctionHallViewController.m
//  ArtisticAuction
//
//  Created by xieran on 2017/4/25.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallViewController.h"
#import "AucationItemDetailViewController.h"
#import "AucationItemsListViewController.h"
#import "AAImagesScrollView.h"
#import "AuctionHallStateView.h"
#import "AuctionHallTitleView.h"
#import "AuctionHallInputView.h"
#import "AuctionHallCellViewModel.h"
#import "AuctionHallTableViewCell.h"
#import "NSMutableArray+AddHallViewModel.h"
#import "AuctionHallCountDownView.h"
#import <MQTTClient/MQTTSessionManager.h>

@interface AuctionHallViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MQTTSessionManagerDelegate>

@property(nonatomic,strong)AuctionHallTitleView *titleView;
@property(nonatomic,strong)AuctionHallStateView *stateView;
@property(nonatomic,strong)AuctionHallInputView *bottomView;
@property(nonatomic,strong)AuctionHallCountDownView *countDownView;

@property(nonatomic,strong)MQTTSessionManager *mqttManager;

@property(nonatomic,strong)AAImagesScrollView *imgScrollView;
@property(nonatomic,strong)UITableView *table;

@property(nonatomic,strong)NSMutableArray *viewModels;
@property(nonatomic,copy)  NSString *cid;

@end

@implementation AuctionHallViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation"]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

    
    self.titleView.occasionLabel.text = self.occasionName;
    self.titleView.agencyLabel.text = self.agencyName;
    
    
    _viewModels = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 100; i++) {
        if (i % 4 == 0) {
            AuctionHallItemIntrolModel *dataModel = [[AuctionHallItemIntrolModel alloc]init];
            
            NSMutableString *str = [[NSMutableString alloc]init];
            for (int j = 0; j < i; j++) {
                [str appendString:@"A"];
            }
            
            dataModel.text = [str copy];
            
            
            AuctionHallItemIntroViewModel *viewModel = [[AuctionHallItemIntroViewModel alloc]init];
            viewModel.dataModel = dataModel;
            
            [self.viewModels addViewModel:viewModel];
        }
        else if (i % 4 == 1){
            AuctionHallSystemModel *dataModel = [[AuctionHallSystemModel alloc]init];
            
            NSMutableString *str = [[NSMutableString alloc]init];
            for (int j = 0; j < i; j++) {
                [str appendString:@"B"];
            }
            
            dataModel.text = [str copy];
        
            
            AuctionHallSyetemViewModel *viewModel = [[AuctionHallSyetemViewModel alloc]init];
            viewModel.dataModel = dataModel;
            
            [self.viewModels addViewModel:viewModel];
        }
        else{
            AuctionHallChatModel *dataModel = [[AuctionHallChatModel alloc]init];

            NSMutableString *str = [[NSMutableString alloc]init];
            for (int j = 0; j < i; j++) {
                [str appendString:@"C"];
            }
            
            dataModel.text = [str copy];
            
            dataModel.userName = @"123123123";
            
            dataModel.time = @"2015-08-25 10:00:00";
            
            AuctionHallChatViewModel *viewModel = [[AuctionHallChatViewModel alloc]init];
            viewModel.dataModel = dataModel;
            
            [self.viewModels addViewModel:viewModel];
        }
    }
    
    


    [self configAutoLayout];
    
    
    [self enterHall];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.countDownView showWithSecond:10];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.countDownView stop];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.countDownView showWithSecond:5];
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)configAutoLayout
{
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    
    [self.imgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
        make.height.equalTo(@(Screen_Width - 100));
    }];
    
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.imgScrollView.mas_bottom);
        make.height.equalTo(@55);
    }];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.stateView.mas_bottom);
        make.bottom.equalTo(self.view).offset(-44);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    [self.countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imgScrollView);
    }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.bottomView isFirstResponder]) {
        [self.bottomView resignFirstResponder];
    }
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AuctionHallCellViewModel *viewModel = self.viewModels[indexPath.row];
    
    NSString *identifier = [viewModel identifier];
    AuctionHallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[viewModel cellClass] alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    [cell setViewModel:viewModel];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AuctionHallCellViewModel *viewModel = self.viewModels[indexPath.row];
    return [viewModel cellHeight];
}

-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma private methods

-(void)enterHall
{
    NSString *guid = [UserInfo sharedInstance].guid;
    
    [HttpManager requestWithAPI:@"user/userEnterLobby" params:@{@"guid" : guid , @"oid" : self.oid} requestMethod:@"GET" completion:^(ASIFormDataRequest *request) {
        NSLog(@"%@",request.responseString);
    } failed:^(ASIFormDataRequest *request) {
        NSLog(@"%@",request.responseString);
    }];
}

-(void)mqttConnect
{
    self.mqttManager = [[MQTTSessionManager alloc]init];
    self.mqttManager.delegate = self;
    
    dispatch_async(dispatch_queue_create("", DISPATCH_QUEUE_SERIAL), ^{
        [self.mqttManager connectTo:ServerUrl port:Port.intValue tls:NO keepalive:60 clean:YES auth:NO user:nil pass:nil willTopic:@"" will:nil willQos:MQTTQosLevelAtMostOnce willRetainFlag:NO withClientId:[UIDevice currentDevice].identifierForVendor.UUIDString];
    });
}

-(void)handleMessage:(NSData *)data onTopic:(NSString *)topic retained:(BOOL)retained
{
    //cid
}

-(void)tapImgView
{
    if (self.cid) {
        AucationItemDetailViewController *vc = [[AucationItemDetailViewController alloc]init];
        vc.cid = self.cid;
        vc.shouldHideBottomView = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)enterItemList
{
    AucationItemsListViewController *vc = [[AucationItemsListViewController alloc]init];
    vc.oid = self.oid;
    vc.shouldHideEnterHallBtn = YES; //隐藏进入拍场的按钮
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)keyboardFrameWillChange:(NSNotification *)notice
{
    NSDictionary *userInfo = notice.userInfo;
    
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:7];
    [UIView setAnimationDuration:duration];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(keyboardFrame.origin.y == Screen_Height ? 0 : -keyboardFrame.size.height);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(AuctionHallTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[NSBundle mainBundle]loadNibNamed:@"AuctionHallTitleView" owner:nil options:nil][0];
        [self.view addSubview:_titleView];
        
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"white_left_arrow_nor"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:backBtn];
        
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleView).offset(18);
            make.width.height.equalTo(@23);
            make.centerY.equalTo(_titleView).offset(10);
        }];
    }
    return _titleView;
}

-(AuctionHallStateView *)stateView
{
    if (!_stateView) {
        _stateView = [[NSBundle mainBundle]loadNibNamed:@"AuctionHallStateView" owner:nil options:nil][0];
        [self.view addSubview:_stateView];
        
        __weak __typeof(self)weakself = self;
        [_stateView setTapItemListBlock:^{
            [weakself enterItemList];
        }];
    }
    return _stateView;
}

-(AuctionHallInputView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle]loadNibNamed:@"AuctionHallInputView" owner:nil options:nil][0];
        [self.view addSubview:_bottomView];
        
        
        [_bottomView setBidBlock:^(NSString *price){
            NSLog(@"%@",price);
        }];
    }
    return _bottomView;
}

-(AAImagesScrollView *)imgScrollView
{
    if (!_imgScrollView) {
        _imgScrollView = [[AAImagesScrollView alloc]init];
        [self.view addSubview:_imgScrollView];
        
        __weak __typeof(self)weakself = self;
        [_imgScrollView setTapBlock:^(NSArray *imgUrls, NSInteger currentIndex, id dataModel) {
            __strong __typeof(self)strongSelf = weakself;
            [strongSelf enterItemList];
        }];
    }
    return _imgScrollView;
}

-(AuctionHallCountDownView *)countDownView
{
    if (!_countDownView) {
        _countDownView = [[AuctionHallCountDownView alloc]init];
        _countDownView.layer.opacity = 0;
        [self.view addSubview:_countDownView];
    }
    return _countDownView;
}

-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc]init];
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundColor = [UIColor clearColor];
        _table.separatorColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
        [self.view addSubview:_table];
    }
    return _table;
}

@end
