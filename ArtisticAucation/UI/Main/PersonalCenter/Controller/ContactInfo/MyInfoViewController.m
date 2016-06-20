//
//  MyInfoViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/28.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "MyInfoViewController.h"
#import "ContactInfoTableViewCell.h"
#import "AddressInfo.h"
#import "EditContactInfoViewController.h"

@interface MyInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView *table;
@property(nonatomic,retain)UIButton *addButton;

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"地址管理";

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.addButton.enabled = [UserInfo sharedInstance].contactInfos.count != 3;
    self.addButton.backgroundColor = [UserInfo sharedInstance].contactInfos.count != 3 ? RedColor : RedColorWithAlpha;
    
    [[NSNotificationCenter defaultCenter]addObserver:self.table selector:@selector(reloadData) name:@"reloadPersonalInfoTable" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.addButton.mas_top);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [UserInfo sharedInstance].contactInfos.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactInfoTableViewCell"];
    if (!cell) {
        cell = [[ContactInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactInfoTableViewCell"];
    }
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    AddressInfo *info = [UserInfo sharedInstance].contactInfos[indexPath.section];
    cell.nameLabel.text = info.name;
    cell.phoneNumLabel.text = info.phoneNum;
    cell.addressLabel.text = info.address;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.didSelectPersonalInfoBlock) {
        self.didSelectPersonalInfoBlock([UserInfo sharedInstance].contactInfos[indexPath.section]);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    EditContactInfoViewController *vc = [[EditContactInfoViewController alloc]init];
    vc.editTag = indexPath.section;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view showLoadingHud];
    
    NSMutableArray *names = [[NSMutableArray alloc]init];
    NSMutableArray *phones = [[NSMutableArray alloc]init];
    NSMutableArray *addresses = [[NSMutableArray alloc]init];
    for (int i = 0; i < [UserInfo sharedInstance].contactInfos.count; i++) {
        AddressInfo *info = [UserInfo sharedInstance].contactInfos[i];
        [names addObject:info.name];
        [phones addObject:info.phoneNum];
        [addresses addObject:info.address];
    }
    
    [names removeObjectAtIndex:indexPath.section];
    [phones removeObjectAtIndex:indexPath.section];
    [addresses removeObjectAtIndex:indexPath.section];
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[UserInfo sharedInstance].userId forKey:@"userid"];
    [params setObject:[names stringSeparateBySymbol:@";"] forKey:@"fullname"];
    [params setObject:[phones stringSeparateBySymbol:@";"] forKey:@"phoneNum"];
    [params setObject:[addresses stringSeparateBySymbol:@";"] forKey:@"address"];
    
    [HttpManager requestWithAPI:@"user/modifyUser" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
        [self.view hideAllHud];
        
        [[UserInfo sharedInstance].contactInfos removeObjectAtIndex:indexPath.section];
        
        [self.table reloadData];
        
        [self viewWillAppear:NO];
    
    } failed:^(ASIFormDataRequest *request) {
        [self.view showHudAndAutoDismiss:NetworkRequestErrorDomain];
    }];

}

#pragma mark Private methods
-(void)addAddress
{
    EditContactInfoViewController *vc = [[EditContactInfoViewController alloc]init];
    vc.editTag = [UserInfo sharedInstance].contactInfos.count;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Properties
-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundView = [UIView backgroundView];
        [self.view addSubview:_table];
    }
    return _table;
}

-(UIButton *)addButton
{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setTitle:@"添加地址" forState:UIControlStateNormal];
        [_addButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_addButton setBackgroundColor:RedColor];
        [_addButton addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addButton];
    }
    return _addButton;
}

@end
