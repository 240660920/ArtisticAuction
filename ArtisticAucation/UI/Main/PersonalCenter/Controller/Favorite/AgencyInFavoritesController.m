//
//  AgencyInCollectionsController.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/22.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AgencyInFavoritesController.h"
#import "AgencyInFavoriteTableCell.h"
#import "MyCollectedAgencyListResponse.h"
#import "AgencyPerformancesViewController.h"
#import "CommonRequests.h"

@interface AgencyInFavoritesController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation AgencyInFavoritesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [[NSMutableArray alloc]init];
    
    [self requestData];
}

-(void)itemPreferenceStateChanged:(NSNotification *)notice
{
    NSDictionary *dic = notice.object;
    
    NSString *itemId = dic[@"itemId"];
    NSString *itemType = dic[@"itemType"];
    NSString *state = dic[@"state"];
    NSString *count = dic[@"count"];
    NSString *preferenceType = dic[@"preferenceType"];
    
    [self.dataSource enumerateObjectsUsingBlock:^(MyCollectedAgencyDataModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.itemType == itemType.intValue && obj.company.aid.intValue == itemId.intValue) {
            if (preferenceType.intValue == kPreferenceTypeLike) {
                obj.company.likeTotals = [count mutableCopy];
                obj.company.likeType = [state mutableCopy];
            }
            else{
                obj.company.collectTotals = [count mutableCopy];
                obj.company.collectType = [state mutableCopy];
            }
        }
    }];
    
    [self.table reloadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AgencyInFavoriteTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AgencyInFavoriteTableCell"];
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    MyCollectedAgencyDetailItem *item = [self.dataSource[indexPath.section]company];
    cell.nameLabel.text = item.aname;

    [cell.likeButton setTitle:item.likeTotals forState:UIControlStateNormal];
    cell.likeButton.selected = item.likeType.boolValue;
    
    [cell.collectButton setTitle:item.collectTotals forState:UIControlStateNormal];
    cell.collectButton.selected = item.collectType.boolValue;
    
    __weak typeof(AgencyInFavoriteTableCell *)weakcell = cell;
    [cell setLikeRequestBlock:^{
        [CommonRequests itemPreferenceRequestWithModel:item itemType:kItemAgency preferenceType:kPreferenceTypeLike viewController:self button:weakcell.likeButton];
    }];
    
    [cell setCollectRequestBlock:^{
        [CommonRequests itemPreferenceRequestWithModel:item itemType:kItemAgency preferenceType:kPreferenceTypeCollect viewController:self button:weakcell.collectButton];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyCollectedAgencyDetailItem *item = [self.dataSource[indexPath.section]company];
    
    AgencyPerformancesViewController *vc = [[AgencyPerformancesViewController alloc]init];
    vc.agencyName = item.aname;
    vc.agencyId = item.aid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Private Methods
-(void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"userid"] = [UserInfo sharedInstance].userId;
    params[@"type"] = @"1001";
    params[@"payment"] = @"3";
    
    [HttpManager requestWithAPI:@"company/queryMyCollect" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {

        MyCollectedAgencyListResponse *response = [[MyCollectedAgencyListResponse alloc]initWithString:request.responseString error:nil];
        if (response && response.result.resultCode.intValue == 0) {
            [self.dataSource addObjectsFromArray:response.data];
        }
        [self.table reloadData];
    
    } failed:^(ASIFormDataRequest *request) {
        [self.table reloadData];
    }];
}

#pragma mark Properties
-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundView = [UIView backgroundView];
        _table.separatorColor = TableViewSeparateColor;
        _table.rowHeight = 70;
        if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [_table setSeparatorInset:UIEdgeInsetsZero];
            
        }
        
        if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [_table setLayoutMargins:UIEdgeInsetsZero];
            
        }
        
        [_table registerNib:[UINib nibWithNibName:@"AgencyInFavoriteTableCell" bundle:nil] forCellReuseIdentifier:@"AgencyInFavoriteTableCell"];
        
        [self.view addSubview:_table];
    }
    return _table;
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
