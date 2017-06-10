//
//  AucationsViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/11.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "AucationsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AucationsCell.h"
#import "AucationsHeader.h"
#import "AucationItemsListViewController.h"
#import "AucationListResponse.h"
#import "FMUString.h"
#import "CommonRequests.h"
#import <MJRefresh/MJRefresh.h>
#import "Remind.h"
#import "AuctionHallViewController.h"
#import "AuctionHallViewController.h"
#import "AdResponse.h"
#import "AAWebViewController.h"
#import "AucationItemDetailViewController.h"

@interface AucationsViewController ()<UIGestureRecognizerDelegate>
{
    UISwipeGestureRecognizer *_leftGesture;
    UISwipeGestureRecognizer *_rightGesture;
}

@property(nonatomic,strong)UILabel *adLabel;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)AucationsHeader *headView;
@property(nonatomic,strong)UILabel *onlineLabel;

@property(nonatomic,strong)NSMutableArray *dataSourceArray;

@end

@implementation AucationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.title = @"拍卖";
    self.navigationItem.leftBarButtonItems = nil;
    
    self.adLabel.hidden = NO;
    
    //获取广告
    [self requestAdvertisement];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self requestList];
}

-(void)itemPreferenceStateChanged:(NSNotification *)notice
{
    NSDictionary *dic = notice.object;
    
    NSString *itemId = dic[@"itemId"];
    NSString *itemType = dic[@"itemType"];
    NSString *state = dic[@"state"];
    NSString *count = dic[@"count"];
    NSString *preferenceType = dic[@"preferenceType"];
    
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
        }
    }];
    
    [self.tableView reloadData];
}

-(void)tapAdLinkUrl:(NSString *)linkUrl
{
    AAWebViewController *vc = [[AAWebViewController alloc]init];
    vc.url = linkUrl;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didSelectSegmentAtIndex:(NSInteger )index
{
    [self.tableView reloadData] ;
}

-(void)swipeAucations:(UISwipeGestureRecognizer *)gesture
{
    if(gesture == _leftGesture)
    {
        [self.headView setSegmentSelectedIndex:1];
    }
    if(gesture == _rightGesture)
    {
        [self.headView setSegmentSelectedIndex:0];
    }
    [self.tableView reloadData];
}

-(void)requestList
{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc]init];
    }
    
    NSMutableDictionary *params = nil;
    if ([UserInfo sharedInstance].loginType != kLoginTypeTraveller) {
        params = [[NSMutableDictionary alloc]init];
        params[@"userid"] = [UserInfo sharedInstance].userId;
    }
    
    [HttpManager requestWithAPI:@"company/getAllOccasion" params:params requestMethod:@"GET" completion:^(ASIFormDataRequest *request) {
        
        [self.dataSourceArray removeAllObjects];

        AucationListResponse *response = [[AucationListResponse alloc]initWithString:request.responseString error:nil];
        
        //服务器时间
        [[TimeManager sharedInstance]setTimeIntervalSince1970:response.nowtime.doubleValue];
        
        if (response && response.result.resultCode.intValue == 0) {

            [self.dataSourceArray addObjectsFromArray:response.data];
            
            [self.dataSourceArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"starttime" ascending:YES]]];
            
            [self.tableView reloadData];
            
        }
        else{
            [self.tableView reloadData];
            [self.view showHudAndAutoDismiss:@"请求失败"];
        }
        
        [self.tableView.mj_header endRefreshing];
    
    } failed:^(ASIFormDataRequest *request) {
        [self.tableView reloadData];
        [self.view showHudAndAutoDismiss:@"网络异常，请检查网络后重试"];
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)requestAdvertisement
{
    [HttpManager requestWithAPI:@"user/getAllAdpicture" params:nil requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
        
        AdResponse *response = [[AdResponse alloc]initWithString:request.responseString error:nil];
        
        self.headView.scrollView.responseModule = response;
        
        
    } failed:^(ASIFormDataRequest *request) {
        
    }];
}

-(void)pushWithAdModel:(AdModel *)adModel
{
    switch (adModel.type) {
        case kAdTypeURL:{
            AAWebViewController *vc = [[AAWebViewController alloc]init];
            vc.url = adModel.linkUrl;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case kAdTypeOccasion:{
            AucationItemsListViewController *vc = [[AucationItemsListViewController alloc]init];
            vc.oid = adModel.paramId;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case kAdTypeCommodity:{
            AucationItemDetailViewController *vc = [[AucationItemDetailViewController alloc]init];
            vc.cid = adModel.paramId;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

-(NSArray *)filteredArray
{
    BOOL isLeft = self.headView.segmentControl.selectedIndex == 0;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status = %@",isLeft ? [NSString stringWithFormat:@"%lu",(unsigned long)DisplayTypePreDisplay] : [NSString stringWithFormat:@"%lu",(unsigned long)DisplayTypeOngoing]];
    NSArray *filteredArray = [self.dataSourceArray filteredArrayUsingPredicate:predicate];
    return filteredArray;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self filteredArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"AucationsCell";
    AucationsCell *cell = (AucationsCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AucationsCell" owner:self options:nil][0];
    }
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    AucationDataModel *model = [self filteredArray][indexPath.section];
    
    cell.status = model.status.intValue;
    
    [cell.backImageV sd_setImageWithURL:[NSURL URLWithString:[model.imgurl completeImageUrlString]] placeholderImage:nil];
    
    cell.titleLabel.text = model.occasionName;
    cell.startTime = model.starttime;
    
    
    [cell.likeBtn           setTitle:model.likeTotals forState:UIControlStateNormal];
    [cell.collectBtn        setTitle:model.collectTotals forState:UIControlStateNormal];
    [cell.aucationAmountBtn setTitle:model.count forState:UIControlStateNormal];
    

    __weak __typeof(AucationsCell *)weakcell = cell;

    
    cell.likeBtn.selected = model.likeType.boolValue;
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
        //AucationHallViewController *vc = [[AucationHallViewController alloc]initWithOid:model.oid agencyName:model.agencyName occasionName:model.occasionName];
        AuctionHallViewController *vc = [[AuctionHallViewController alloc]init];
        vc.oid = model.oid;
        vc.occasionName = model.occasionName;
        vc.agencyName = model.agencyName;
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [AucationsCell heightForRow];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AucationDataModel *model = [self filteredArray][indexPath.section];
    
    AucationItemsListViewController *controller = [[AucationItemsListViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.oid = model.oid;
    controller.aucationModel = model;
    [self.navigationController pushViewController:controller animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Private Methods


#pragma mark Properties
-(UILabel *)adLabel
{
    if (!_adLabel) {
        _adLabel = [UILabel new];
        _adLabel.textColor = [UIColor whiteColor];
        _adLabel.textAlignment = NSTextAlignmentCenter;
        _adLabel.font = [UIFont systemFontOfSize:13];
        _adLabel.backgroundColor = [UIColor colorWithRed:153.0/255.0 green:15.0/255.0 blue:38.0/255.0 alpha:0.6];
        _adLabel.text = @"让艺术品走进你家我家";
        
        [self.view insertSubview:_adLabel aboveSubview:self.tableView];
        
        [_adLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@20);
            make.top.equalTo(self.view);
        }];
    }
    return _adLabel;
}

-(AucationsHeader *)headView
{
    if (!_headView) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"AHeader" owner:nil options:nil];
        _headView= (AucationsHeader*)[nibContents objectAtIndex:0];
        _headView.delegate = self;
        
        __weak __typeof(self)weakself = self;

        
        [_headView.scrollView setTapBlock:^(NSArray *imgUrls, NSInteger currentIndex, id dataModel) {
            AdModel *adModel = (AdModel *)dataModel;
            [weakself pushWithAdModel:adModel];
        }];
    }
    return _headView;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundView = [UIView backgroundView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headView;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestList];
            [self requestAdvertisement];
        }];
        
        _leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAucations:)];
        [_leftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
        [_tableView addGestureRecognizer:_leftGesture];
        
        _rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAucations:)];
        [_rightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
        [_tableView addGestureRecognizer:_rightGesture];
        
        
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view);
        }];
    }
    return _tableView;
}

@end
