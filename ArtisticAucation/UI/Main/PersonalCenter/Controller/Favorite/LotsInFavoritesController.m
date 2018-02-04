//
//  AucationsInCollectionsController.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/22.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "LotsInFavoritesController.h"
#import "AucationItemCell.h"
#import "AucationItemsListResponse.h"
#import "MyCollectedLotsListResponse.h"
#import "CommonRequests.h"
#import "AucationItemDetailViewController.h"

@interface LotsInFavoritesController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UITableView *table;
@property(nonatomic,retain)NSMutableArray *dataSourceArray;

@end

@implementation LotsInFavoritesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSourceArray = [[NSMutableArray alloc]init];
    
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
    
    [self.dataSourceArray enumerateObjectsUsingBlock:^(MyCollectedLotItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.commodity.itemType == itemType.intValue && obj.commodity.cid.intValue == itemId.intValue) {
            if (preferenceType.intValue == kPreferenceTypeLike) {
                obj.commodity.likeTotals = [count mutableCopy];
                obj.commodity.likeType = [state mutableCopy];
            }
            else{
                obj.commodity.collectTotals = [count mutableCopy];
                obj.commodity.collectType = [state mutableCopy];
            }
        }
    }];
    
    [self.table reloadData];
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AucationItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LotsInFavoriteTableCell"];
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    if (!cell) {
        cell = [[AucationItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LotsInFavoriteTableCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    MyCollcetedLotDetailItem *module = [self.dataSourceArray[indexPath.row]commodity];
    
    cell.titleLabel.text = module.name;

   
    [cell.picImageV sd_setImageWithURL:[NSURL URLWithString:[module.images[0]completeImageUrlString]] placeholderImage:AucationItem_PlaceHolderImage];
    cell.picImageV.dealState = module.status.intValue;
    
    
    cell.price.attributedText = [NSString redPriceOfValue:module.endprice.length == 0 ? module.startprice : module.endprice];
    
    [cell.likeBtn setTitle:module.likeTotals forState:UIControlStateNormal];
    [cell.collectBtn setTitle:module.collectTotals forState:UIControlStateNormal];
    
    cell.likeBtn.selected = module.likeType.boolValue;
    cell.collectBtn.selected = module.collectType.boolValue;
    

    __weak __typeof(UIButton *)weakLikeBtn = cell.likeBtn;
    [cell setLikeRequestBlock:^{
        [CommonRequests itemPreferenceRequestWithModel:module itemType:kItemAucationItem preferenceType:kPreferenceTypeLike viewController:self button:weakLikeBtn];
    }];

    
    __weak __typeof(UIButton *)weakCollectBtn = cell.collectBtn;
    [cell setCollectRequestBlock:^{
        [CommonRequests itemPreferenceRequestWithModel:module itemType:kItemAucationItem preferenceType:kPreferenceTypeCollect viewController:self button:weakCollectBtn];
        
        [self.dataSourceArray removeObjectAtIndex:indexPath.row];
        [self.table reloadData];
    }];
    
    cell.countDownView.aucationState = DisplayTypeNone;
    cell.countDownView.itemState = module.status.intValue;
    cell.countDownView.startTime = module.starttime;
    [cell.countDownView refresh];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AucationItemDetailViewController *vc = [[AucationItemDetailViewController alloc]init];
    NSString *cid = [[self.dataSourceArray[indexPath.row] commodity] cid];
    vc.cid = cid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Private Methods
-(void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"userid"] = [UserInfo sharedInstance].userId;
    params[@"type"] = @"1003";
    params[@"payment"] = @"3";
    
    [HttpManager requestWithAPI:@"company/queryMyCollect" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
        
        MyCollectedLotsListResponse *response = [[MyCollectedLotsListResponse alloc]initWithString:request.responseString error:nil];
        [self.dataSourceArray addObjectsFromArray:response.data];
        
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
        _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.rowHeight = 120;
        _table.separatorColor = TableViewSeparateColor;
        _table.backgroundView = [UIView backgroundView];        
        [_table registerNib:[UINib nibWithNibName:@"AucationItemCell" bundle:nil] forCellReuseIdentifier:@"LotsInFavoriteTableCell"];

        
        [self.view addSubview:_table];
    }
    return _table;
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

@end
