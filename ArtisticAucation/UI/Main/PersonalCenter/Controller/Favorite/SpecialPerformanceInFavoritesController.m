//
//  AucationsInFavoritesController.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/22.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "SpecialPerformanceInFavoritesController.h"
#import "SpecialPerformanceInFavoriteCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyCollectedPerformancesResponse.h"
#import "CommonRequests.h"
#import "AucationItemsListViewController.h"

@interface AucationsTableCell : UITableViewCell

@end

@implementation AucationsTableCell

@end


@interface SpecialPerformanceInFavoritesController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation SpecialPerformanceInFavoritesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.dataSource = [[NSMutableArray alloc]init];

    [self requestData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)itemPreferenceStateChanged:(NSNotification *)notice
{
    NSDictionary *dic = notice.object;
    
    NSString *itemId = dic[@"itemId"];
    NSString *itemType = dic[@"itemType"];
    NSString *state = dic[@"state"];
    NSString *count = dic[@"count"];
    NSString *preferenceType = dic[@"preferenceType"];
    
    [self.dataSource enumerateObjectsUsingBlock:^(MyCollectedPerformanceItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.itemType == itemType.intValue && obj.occasion.oid.intValue == itemId.intValue) {
            if (preferenceType.intValue == kPreferenceTypeLike) {
                obj.occasion.likeTotals = [count mutableCopy];
                obj.occasion.likeType = [state mutableCopy];
            }
            else{
                obj.occasion.collectTotals = [count mutableCopy];
                obj.occasion.collectType = [state mutableCopy];
            }
        }
    }];
    
    [self.table reloadData];
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"SpecialPerformanceInFavoriteCell";
    
    SpecialPerformanceInFavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SpecialPerformanceInFavoriteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    MyCollectedPerformancesDetail *module = [self.dataSource[indexPath.section] occasion];
    
    
    [cell.performanceImageView sd_setImageWithURL:[NSURL URLWithString:[module.imgurl completeImageUrlString]] placeholderImage:nil];
    cell.nameLabel.text = module.odescription;
    
    [cell.likeButton setTitle:module.likeTotals forState:UIControlStateNormal];
    [cell.collectButton setTitle:module.collectTotals forState:UIControlStateNormal];
    [cell.aucationButton setTitle:module.count forState:UIControlStateNormal];
    
    cell.likeButton.selected = module.likeType.boolValue;
    cell.collectButton.selected = module.collectType.boolValue;
    
    
    __weak __typeof(UIButton *)weakLikeBtn = cell.likeButton;
    [cell setLikeRequestBlock:^{
        [CommonRequests itemPreferenceRequestWithModel:module itemType:kItemSpecialPerformance preferenceType:kPreferenceTypeLike viewController:self button:weakLikeBtn];
    }];
    
    
    __weak __typeof(UIButton *)weakCollectBtn = cell.collectButton;
    [cell setCollectRequestBlock:^{
        [CommonRequests itemPreferenceRequestWithModel:module itemType:kItemSpecialPerformance preferenceType:kPreferenceTypeCollect viewController:self button:weakCollectBtn];
        
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.table reloadData];
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyCollectedPerformancesDetail *item = (MyCollectedPerformancesDetail *)[self.dataSource[indexPath.section]occasion];
    
    AucationDataModel *aucationModel = [[AucationDataModel alloc]init];
    aucationModel.oid = item.oid;
    aucationModel.aid = item.aid;
    aucationModel.likeTotals = item.likeTotals;
    aucationModel.likeType = item.likeType;
    aucationModel.collectTotals = item.collectTotals;
    aucationModel.collectType = item.collectType;
//    aucationModel.agencyName = item.ag
    aucationModel.occasionName = item.odescription;
    aucationModel.imgurl = item.imgurl;
    aucationModel.remindType = item.remindType;
    aucationModel.status = item.status;
    
    AucationItemsListViewController *vc = [[AucationItemsListViewController alloc]init];
    vc.oid = item.oid;
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
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
    params[@"type"] = @"1002";
    params[@"payment"] = @"3";
    
    [HttpManager requestWithAPI:@"company/queryMyCollect" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {

        MyCollectedPerformancesResponse *response = [[MyCollectedPerformancesResponse alloc]initWithString:request.responseString error:nil];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:response.data];
    
        [self.table reloadData];
    
    } failed:^(ASIFormDataRequest *request) {
        [self.table reloadData];
        
        [self.view showHudAndAutoDismiss:NetworkErrorPrompt];
    }];
}

#pragma mark Properties
-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundColor = [UIColor clearColor];
        _table.separatorColor = TableViewSeparateColor;
        _table.rowHeight = [SpecialPerformanceInFavoriteCell heightForRow];
        _table.backgroundView = [UIView backgroundView];
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
