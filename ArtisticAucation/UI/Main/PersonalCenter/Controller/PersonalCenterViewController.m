//
//  PersonalCenterViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/11.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "MyFavoritesViewController.h"
#import "MyLotsViewController.h"
#import "MyInfoViewController.h"
#import "MyRemindViewController.h"
#import "AboutUsViewController.h"
#import "PersonalCenterTableCell.h"
#import "AucationItemDetailViewController.h"
#import "ModifyPasswordViewController.h"

#define YuanFont [UIFont systemFontOfSize:24]
#define JiaofenFont [UIFont systemFontOfSize:12]

@interface PersonalCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{

}
@property(nonatomic,strong)NSMutableDictionary *controllerDic;
@property(nonatomic,strong)NSArray *keys;
@property(nonatomic,strong)NSArray *iconImages;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)UIImageView *headerView;
//@property(nonatomic,strong)UILabel *fundsLabel;
//@property(nonatomic,strong)UILabel *promptLabel;
//@property(nonatomic,strong)UIButton *withdrawDepositButton;
@property(nonatomic,strong)UIButton *loginButton;
@property(nonatomic,strong)UILabel *quitLabel;
@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation PersonalCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.titleLabel.text = @"个人中心";
    self.titleLabel.textColor = [UIColor whiteColor];
    
    
    _controllerDic = [[NSMutableDictionary alloc] initWithCapacity:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.loginButton.hidden = [UserInfo sharedInstance].loginType != kLoginTypeTraveller;
    
    self.navigationController.navigationBarHidden = YES;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat headerHeight = iPhone4S ? 170 : self.headerView.image.size.height - 60;
    
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@(headerHeight));
    }];
    
//    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.top.equalTo(@(headerHeight * 0.4));
//    }];
    
    
//    [self.fundsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX).offset(2);
//        make.top.equalTo(self.promptLabel.mas_bottom).offset(15);
//    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(8);
        make.centerY.equalTo(self.titleLabel);
    }];
    
//    [self.withdrawDepositButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.headerView).offset(-8);
//        make.centerY.equalTo(self.titleLabel);
//    }];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return self.keys.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = self.keys[indexPath.row];
    PersonalCenterTableCell *cell = [[PersonalCenterTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonalCenterTable"];
    
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    if (indexPath.section == 0) {
        cell.textLabel.text = title;
        cell.textLabel.textColor = BlackColor;
        cell.imageView.image = self.iconImages[indexPath.row];
    }
    else{
        cell.imageView.image = nil;
        cell.textLabel.text = nil;
        [self.quitLabel removeFromSuperview];
        [cell.contentView addSubview:self.quitLabel];
        self.quitLabel.center = cell.contentView.center;
        if ([UserInfo sharedInstance].loginType == kLoginTypeTraveller) {
            self.quitLabel.alpha = 0.4;
        }
        else{
            self.quitLabel.alpha = 1;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        if ((indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) && [UserInfo sharedInstance].loginType == kLoginTypeTraveller) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请先登录" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"前往登录", nil];
            [alert handleClickedButton:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
            [alert show];
            return;
        }
        
        NSString *key = self.keys[indexPath.row];
        UIViewController *controller = self.controllerDic[key];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else{
        if ([UserInfo sharedInstance].loginType != kLoginTypeTraveller) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"确定退出当前账号？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [actionSheet showInView:self.view];
        }
    }
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {        
        [UserInfo clearUserInfo];

        [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Private Methods
-(void)login
{
    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
}

////提现
//-(void)withdrawDeposit
//{
//
//}

#pragma mark Properties
-(NSArray *)keys
{
    if (!_keys) {
        _keys = @[@"我的收藏",@"我的拍品",@"地址管理",@"我的提醒",@"修改密码",@"关于我们"];
    }
    return _keys;
}

-(NSArray *)iconImages
{
    if (!_iconImages) {
        _iconImages = @[[UIImage imageNamed:@"p_c_icon_favorite"],[UIImage imageNamed:@"p_c_icon_lots"],[UIImage imageNamed:@"p_c_icon_info"],[UIImage imageNamed:@"p_c_icon_alert"],[UIImage imageNamed:@"p_c_icon_password"],[UIImage imageNamed:@"p_c_icon_about_us"]];
    }
    return _iconImages;
}

-(NSMutableDictionary *)controllerDic
{
    if([_controllerDic count] > 0)
    {
        [_controllerDic removeAllObjects];
    }
    [_controllerDic setObject:[[MyFavoritesViewController alloc]init] forKey:self.keys[0]];
    [_controllerDic setObject:[[MyLotsViewController alloc]init] forKey:self.keys[1]];
    [_controllerDic setObject:[[MyInfoViewController alloc]init] forKey:self.keys[2]];
    [_controllerDic setObject:[[MyRemindViewController alloc]init] forKey:self.keys[3]];
    [_controllerDic setObject:[[ModifyPasswordViewController alloc]init] forKey:self.keys[4]];
    [_controllerDic setObject:[[AboutUsViewController alloc]init] forKey:self.keys[5]];
    return _controllerDic;
}

-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundColor = [UIColor clearColor];
        _table.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        _table.rowHeight = 45;
        _table.backgroundView = [UIView backgroundView];
        [self.view addSubview:_table];
    }
    return _table;
}

-(UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIImageView alloc]init];
        _headerView.userInteractionEnabled = YES;
        _headerView.image = [UIImage imageNamed:@"personal_center_header"];
        [self.view insertSubview:_headerView belowSubview:self.titleLabel];
    }
    return _headerView;
}

//-(UILabel *)fundsLabel
//{
//    if (!_fundsLabel) {
//        _fundsLabel = [[UILabel alloc]init];
//        _fundsLabel.textAlignment = NSTextAlignmentCenter;
//        _fundsLabel.textColor = [UIColor whiteColor];
//        [self.headerView addSubview:_fundsLabel];
//    }
//    return _fundsLabel;
//}

//-(UILabel *)promptLabel
//{
//    if (!_promptLabel) {
//        _promptLabel = [[UILabel alloc]init];
//        _promptLabel.font = [UIFont systemFontOfSize:17];
//        _promptLabel.textColor = [UIColor whiteColor];
//        _promptLabel.textAlignment = NSTextAlignmentCenter;
//        _promptLabel.text = @"余额";
//        [self.headerView addSubview:_promptLabel];
//    }
//    return _promptLabel;
//}

-(UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTintColor:[UIColor whiteColor]];
        [_loginButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [self.headerView addSubview:_loginButton];
    }
    return _loginButton;
}

//-(UIButton *)withdrawDepositButton
//{
//    if (!_withdrawDepositButton) {
//        _withdrawDepositButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_withdrawDepositButton setTitle:@"提现" forState:UIControlStateNormal];
//        [_withdrawDepositButton setTintColor:[UIColor whiteColor]];
//        [_withdrawDepositButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
//        [_withdrawDepositButton addTarget:self action:@selector(withdrawDeposit) forControlEvents:UIControlEventTouchUpInside];
//        [self.headerView addSubview:_withdrawDepositButton];
//    }
//    return _withdrawDepositButton;
//}

-(UILabel *)quitLabel
{
    if (!_quitLabel) {
        _quitLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
        _quitLabel.font = [UIFont systemFontOfSize:16];
        _quitLabel.textAlignment = NSTextAlignmentCenter;
        _quitLabel.text = @"退出当前账号";
        _quitLabel.textColor = RedColor;
        _quitLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return _quitLabel;
}


-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, self.navigationController.navigationBar.frame.size.height)];
        _titleLabel.font = NavigationBarTitleFont;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = NavigationBarTitleColor;
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
