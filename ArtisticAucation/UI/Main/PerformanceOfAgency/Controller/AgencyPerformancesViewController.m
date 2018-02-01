//
//  AgencyListViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/22.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AgencyPerformancesViewController.h"
#import "SpecialPerformanceInFavoriteCell.h"
#import "AgencyItemResponse.h"
#import "CommonRequests.h"
#import "AucationsCell.h"
#import "Remind.h"
#import "AuctionHallViewController.h"
#import "AucationItemsListViewController.h"
#import "AgencyHeaderView.h"

@interface AgencyPerformancesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView *table;

@property(nonatomic,retain)NSMutableArray *dataSourceArray;

@property(nonatomic,retain)AgencyItem *agencyItem;
@property(nonatomic,retain)AgencyHeaderView *headerView;

@end

@implementation AgencyPerformancesViewController

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"送拍机构";
    
    _dataSourceArray = [[NSMutableArray alloc]init];
    
    self.navigationItem.title = self.agencyName;
    
    [self requestData];
    [self requestAgencyDetail];
    
}

-(void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if ([UserInfo sharedInstance].loginType != kLoginTypeTraveller) {
        params[@"userid"] = [UserInfo sharedInstance].userId;
    }
    params[@"aid"] = self.agencyId;
    
    [HttpManager requestWithAPI:@"company/getOneCompanyOccasion" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
       
        AgencyItemResponse *response = [[AgencyItemResponse alloc]initWithString:request.responseString error:nil];
        if (response && response.result.resultCode.intValue == 0) {
            self.agencyItem = response.data;
            
            for (AucationDataModel *model in response.data.listOccasion) {
                model.agencyName = self.agencyName;
            }
            
            [self.dataSourceArray addObjectsFromArray:response.data.listOccasion];
            
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@""];
//            [self.dataSourceArray filterUsingPredicate:predicate];
            
            [self.table reloadData];
            
        }
        
    } failed:^(ASIFormDataRequest *request) {
        
    }];
}

-(void)requestAgencyDetail
{
    [HttpManager requestWithAPI:@"company/queryOneCompany" params:@{@"userid" : [UserInfo sharedInstance].userId , @"aid" : self.agencyId} requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
       
        AgencyItemResponse *item = [[AgencyItemResponse alloc]initWithString:request.responseString error:nil];
        
        self.table.tableHeaderView = self.headerView;
        
        self.headerView.likeButton.selected = item.data.likeType.boolValue;
        [self.headerView.likeButton setTitle:item.data.likeTotals forState:UIControlStateNormal];
        
        self.headerView.collectButton.selected = item.data.collectType.boolValue;
        [self.headerView.collectButton setTitle:item.data.collectTotals forState:UIControlStateNormal];
        
        
        [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:[item.data.imgurl completeImageUrlString]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                self.headerView.image = image;
                self.headerView.frame = CGRectMake(0, 0, Screen_Width, [AgencyHeaderView heightForImage:image]);
                self.table.tableHeaderView = self.headerView;
                [self.table reloadData];
            }
        }];
        
    } failed:^(ASIFormDataRequest *request) {
        [self.view showHudAndAutoDismiss:NetworkErrorPrompt];
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
    
    
    if (self.agencyItem.itemType == itemType.intValue && self.agencyItem.aid.intValue == itemId.intValue) {
        if (preferenceType.intValue == kPreferenceTypeLike) {
            self.agencyItem.likeTotals = [count mutableCopy];
            self.agencyItem.likeType = [state mutableCopy];
            
            self.headerView.likeButton.selected = state.boolValue;
            [self.headerView.likeButton setTitle:count forState:UIControlStateNormal];
        }
        else{
            self.agencyItem.collectTotals = [count mutableCopy];
            self.agencyItem.collectType = [state mutableCopy];
            
            self.headerView.collectButton.selected = state.boolValue;
            [self.headerView.collectButton setTitle:count forState:UIControlStateNormal];
        }
    }
    else{
        [self.dataSourceArray enumerateObjectsUsingBlock:^(AucationDataModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.itemType == itemType.intValue && obj.oid.intValue == itemId.intValue) {
                if (preferenceType.intValue == kPreferenceTypeLike) {
                    obj.likeTotals = [count mutableCopy];
                    obj.likeType = [state mutableCopy];
                }
                else{
                    obj.collectTotals = [count mutableCopy];
                    obj.collectType = [state mutableCopy];
                }
                [self.table reloadData];
            }
        }];
    }
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceArray.count;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"AucationsCell";
    AucationsCell *cell = (AucationsCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AucationsCell" owner:self options:nil][0];
    }
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    AucationDataModel *model = self.dataSourceArray[indexPath.section];

    
    cell.status = model.status.intValue;
    
    [cell.remindBtn setTitle:model.remindType.boolValue == YES ? @"已设置提醒" : @"提醒" forState:UIControlStateNormal];
    [cell.remindBtn setImage:model.remindType.boolValue == YES ? nil : [UIImage imageNamed:@"remind_clock"] forState:UIControlStateNormal];
    
    
    [cell.backImageV sd_setImageWithURL:[NSURL URLWithString:[model.imgurl completeImageUrlString]] placeholderImage:nil];
    
    
    cell.titleLabel.text = model.occasionName;
    cell.startTime = model.starttime;
    
    [cell.likeBtn           setTitle:model.likeTotals forState:UIControlStateNormal];
    [cell.collectBtn        setTitle:model.collectTotals forState:UIControlStateNormal];
    [cell.aucationAmountBtn setTitle:model.count forState:UIControlStateNormal];
    
    
    cell.likeBtn.selected = model.likeType.boolValue;
    __weak __typeof(AucationsCell *)weakcell = cell;
    [cell setLikeRequestBlock:^(void){
        
        
        [CommonRequests itemPreferenceRequestWithModel:model itemType:kItemSpecialPerformance preferenceType:kPreferenceTypeLike viewController:self button:weakcell.likeBtn];
        
        
    }];
    
    cell.collectBtn.selected = model.collectType.boolValue;
    [cell setCollectRequestBlock:^(void){
        
        
        [CommonRequests itemPreferenceRequestWithModel:model itemType:kItemSpecialPerformance preferenceType:kPreferenceTypeCollect viewController:self button:weakcell.collectBtn];
        
    }];
    
    cell.remindBtn.selected = model.remindType.boolValue;
    [cell setPushBlock:^(void){
        //设置提醒
        //判断是否登录
        if ([UserInfo sharedInstance].loginType == kLoginTypeTraveller) {
            [self showLoginAlert];
            return ;
        }
        [Remind setRemindWithSessionId:model.oid startTime:model.starttime andOccasionName:model.occasionName remindButton:weakcell.remindBtn];
    }];
    
    [cell setHallBlock:^(void){
        //进入拍卖大厅
        AuctionHallViewController *vc = [[AuctionHallViewController alloc]init];
        vc.oid = model.agencyName;
        vc.agencyName = model.agencyName;
        vc.occasionName = model.occasionName;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1 / [UIScreen mainScreen].scale;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    return v;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    return v;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AucationDataModel *model = self.dataSourceArray[indexPath.section];

    AucationItemsListViewController *vc = [[AucationItemsListViewController alloc]init];
    vc.oid = model.oid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Private Methods
-(void)like:(UIButton *)sender
{
    [CommonRequests itemPreferenceRequestWithModel:self.agencyItem itemType:kItemAgency preferenceType:kPreferenceTypeLike viewController:self button:sender];
}

-(void)collect:(UIButton *)sender
{
    [CommonRequests itemPreferenceRequestWithModel:self.agencyItem itemType:kItemAgency preferenceType:kPreferenceTypeCollect viewController:self button:sender];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(AgencyHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[AgencyHeaderView alloc]init];
        _headerView.frame = CGRectMake(0, 0, Screen_Width, Screen_Width / 2 + 40);
        [_headerView.likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.collectButton addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _table.delegate = self;
        _table.dataSource = self;
        _table.rowHeight = [AucationsCell heightForRow];
        _table.backgroundView = [UIView backgroundView];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_table registerNib:[UINib nibWithNibName:@"AucationsCell" bundle:nil] forCellReuseIdentifier:@"AucationsCell"];
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
