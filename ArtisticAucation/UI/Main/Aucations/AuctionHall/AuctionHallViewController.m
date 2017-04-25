//
//  AuctionHallViewController.m
//  ArtisticAuction
//
//  Created by xieran on 2017/4/25.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallViewController.h"
#import "AuctionHallStateView.h"
#import "AuctionHallTitleView.h"
#import "AuctionHallInputView.h"

@interface AuctionHallViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(nonatomic,strong)AuctionHallTitleView *titleView;
@property(nonatomic,strong)AuctionHallStateView *stateView;
@property(nonatomic,strong)AuctionHallInputView *bottomView;

@property(nonatomic,strong)UIView *topBar;
@property(nonatomic,strong)UITableView *table;

@end

@implementation AuctionHallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"拍卖大厅";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation"]];
    
    self.titleView.occasionLabel.text = self.occasionName;
    self.titleView.agencyLabel.text = self.agencyName;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewDidLayoutSubviews
{
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.topBar);
        make.top.equalTo(self.topBar.mas_bottom);
        make.height.equalTo(@70);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
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
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[UITableViewCell alloc]init];
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
    }
    return _titleView;
}

-(AuctionHallStateView *)stateView
{
    if (!_stateView) {
        _stateView = [[NSBundle mainBundle]loadNibNamed:@"AuctionHallStateView" owner:nil options:nil][0];
    }
    return _stateView;
}

-(AuctionHallInputView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle]loadNibNamed:@"AuctionHallInputView" owner:nil options:nil][0];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

-(UIView *)topBar
{
    if (!_topBar) {
        _topBar = [[UIView alloc]init];
        _topBar.backgroundColor = RedColor;
        
        [self.view addSubview:_topBar];
        
        [_topBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.equalTo(@64);
        }];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"white_left_arrow_nor"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        [_topBar addSubview:backBtn];
        
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_topBar).offset(18);
            make.width.height.equalTo(@23);
            make.bottom.equalTo(_topBar).offset(-(44 - 23) / 2);
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = NavigationBarTitleFont;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"拍卖大厅";
        [_topBar addSubview:titleLabel];
        
        [titleLabel sizeToFit];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_topBar);
            make.bottom.equalTo(_topBar).offset(-(44 - titleLabel.frame.size.height) / 2);
        }];
    }
    return _topBar;
}

-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc]init];
        _table.delegate = self;
        _table.dataSource = self;
        [self.view addSubview:_table];
    }
    return _table;
}

@end
