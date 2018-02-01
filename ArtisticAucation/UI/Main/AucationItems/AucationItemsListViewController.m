//
//  SessionViewController.m
//  ArtisticAucation
//
//  Created by Haley on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationItemsListViewController.h"
#import "AucationItemCell.h"
#import "SessionHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AucationItemsListResponse.h"
#import "NSString+PriceString.h"
#import "AucationItemDetailViewController.h"
#import "CommonRequests.h"
#import "AuctionHallViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "Remind.h"
#import "WXApiObject.h"
#import "WXApi.h"

@interface AucationItemsListViewController ()<UIActionSheetDelegate>

@property(nonatomic,retain)SessionHeader *tableHeaderView;
@property(nonatomic,retain)NSMutableArray *dataSourceArray;
@property(nonatomic,retain)NSTimer *refreshTimer;
@property(nonatomic,strong)UIView *bottomView;

@end

@implementation AucationItemsListViewController

-(void)dealloc
{
    [self.refreshTimer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"专场拍卖列表";

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 23, 23);
    [rightButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(requestData) userInfo:nil repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self requestData];
}

-(void)share
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"分享到：" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友",@"微信朋友圈", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 2) {
        int scene = buttonIndex == 0 ? WXSceneSession : WXSceneTimeline;
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = [NSString stringWithFormat:@"%@%@?oid=%@",ServerUrl,@"Auction/list2.html",self.oid];
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = [NSString stringWithFormat:@"%@的拍品列表",self.aucationModel.occasionName];
        message.description = @"";
        [message setThumbImage:[UIImage imageNamed:@"icon"]];
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
        req.message = message;
        req.scene = scene;
        
        [WXApi sendReq:req];
    }
}

-(void)itemPreferenceStateChanged:(NSNotification *)notice
{
    NSDictionary *dic = notice.object;
    
    NSString *itemId = dic[@"itemId"];
    NSString *itemType = dic[@"itemType"];
    NSString *state = dic[@"state"];
    NSString *count = dic[@"count"];
    NSString *preferenceType = dic[@"preferenceType"];
    
    if (itemType.intValue == kItemSpecialPerformance) {
        if (preferenceType.intValue == kPreferenceTypeLike) {
            self.tableHeaderView.likeBtn.selected = state.boolValue;
            [self.tableHeaderView.likeBtn setTitle:count forState:UIControlStateNormal];

        }
        else{
            self.tableHeaderView.collectBtn.selected = state.boolValue;
            [self.tableHeaderView.collectBtn setTitle:count forState:UIControlStateNormal];
        }
        return;
    }
    
    
    [self.dataSourceArray enumerateObjectsUsingBlock:^(LotResponse *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.itemType == itemType.intValue && obj.cid.intValue == itemId.intValue) {
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

-(void)requestAucationInfo
{

}

-(void)requestData
{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc]init];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if ([UserInfo sharedInstance].loginType != kLoginTypeTraveller) {
        params[@"userid"] = [UserInfo sharedInstance].userId;
    }
    params[@"oid"] = self.oid;
    
    [HttpManager requestWithAPI:@"company/queryCommodity" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {

        [_dataSourceArray removeAllObjects];

        AucationItemsListResponse *response = [[AucationItemsListResponse alloc]initWithString:request.responseString error:nil];
        self.aucationModel = response.data;
        if (response && response.result.resultCode.intValue == 0 && response.data.commodity.count > 0) {
            
            NSTimeInterval leftTimeInterval = [TimeManager timeIntervalBetweenServerTimeAndTime:response.data.starttime];
            if (leftTimeInterval > 0) {
                [self.refreshTimer invalidate];
                self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(requestData) userInfo:nil repeats:NO];
                [self.refreshTimer setFireDate:[[NSDate date] dateByAddingTimeInterval:leftTimeInterval + 2]];
            }
            else{
                [self.refreshTimer invalidate];
            }
            
            
            [self.dataSourceArray addObjectsFromArray:response.data.commodity];
            [self.tableView reloadData];
            
            [self.tableHeaderView setStatus:response.data.status.intValue];
            [self.tableHeaderView.amountBtn setTitle:response.data.count forState:UIControlStateNormal];
            self.tableHeaderView.mainLabel.text = response.data.occasionName;
            
            [self.tableHeaderView.likeBtn setTitle:response.data.likeTotals forState:UIControlStateNormal];
            [self.tableHeaderView.collectBtn setTitle:response.data.collectTotals forState:UIControlStateNormal];
            [self.tableHeaderView.likeBtn setSelected:response.data.likeType.boolValue];
            [self.tableHeaderView.collectBtn setSelected:response.data.collectType.boolValue];
            [self.tableHeaderView.remindBtn setSelected:response.data.remindType.boolValue];
            
            __weak typeof(self)weafself = self;

            /*提醒按钮点击事件*/
            [weafself.tableHeaderView setRemindBlock:^(void){
                if ([UserInfo sharedInstance].loginType == kLoginTypeTraveller) {
                    [weafself showLoginAlert];
                    return ;
                }
                [Remind setRemindWithSessionId:weafself.oid startTime:response.data.starttime andOccasionName:response.data.occasionName remindButton:weafself.tableHeaderView.remindBtn];
            }];
            /**/
            
            [weafself.tableHeaderView.backImageV sd_setImageWithURL:[NSURL URLWithString:[response.data.imgurl completeImageUrlString]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                [_tableHeaderView layoutSubviews];
                _tableView.tableHeaderView = _tableHeaderView;
                [_tableView reloadData];
            }];

            //提醒按钮、进入拍卖大厅按钮(进入拍场的view是固定在底部的，table的位置要根据它调整)
            if (response.data.status.intValue == DisplayTypePreDisplay) {
                self.tableHeaderView.remindBtn.hidden = NO;
                
                self.bottomView.hidden = YES;
                
                self.tableView.frame = self.view.bounds;
            }
            else if(response.data.status.intValue == DisplayTypeOngoing){
                self.tableHeaderView.remindBtn.hidden = YES;
                
                self.bottomView.hidden = NO;

                self.tableView.frame = CGRectMake(0, 0, Screen_Width, self.view.frame.size.height - self.bottomView.frame.size.height);
            }
            else{
                self.tableHeaderView.remindBtn.hidden = YES;
                
                
                self.bottomView.hidden = YES;

                self.tableView.frame = self.view.bounds;
            }
        }
        else{
            [self.tableView reloadData];
        }

        
        //专场正在审核中的话是没有拍品数据的
        if (_dataSourceArray.count == 0) {
            [self.view showHudAndAutoDismiss:@"暂无拍品"];
        }
        
        [self.tableView.mj_header endRefreshing];
        
    } failed:^(ASIFormDataRequest *request) {
        [self.dataSourceArray removeAllObjects];
        [self.tableView reloadData];
        
        [self.view showHudAndAutoDismiss:NetworkErrorPrompt];
        
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    AucationItemCell *cell = (AucationItemCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AucationItemCell" owner:self options:nil][0];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    LotResponse *item = self.dataSourceArray[indexPath.row];
    if (item.images.count > 0) {
        [cell.picImageV sd_setImageWithURL:[NSURL URLWithString:[item.images[0] completeImageUrlString]] placeholderImage:AucationItem_PlaceHolderImage];
    }
    else{
        [cell.picImageV setImage:AucationItem_PlaceHolderImage];
    }
    cell.titleLabel.text = item.name;
    
    
    NSString *price = item.endprice.length == 0 ? item.startprice : item.endprice;
    cell.price.attributedText = [NSString redPriceOfValue:price];
    cell.picImageV.dealState = item.status.intValue;
    
    [cell.likeBtn setTitle:item.likeTotals forState:UIControlStateNormal];
    [cell.collectBtn setTitle:item.collectTotals forState:UIControlStateNormal];
    
    
    cell.likeBtn.selected = item.likeType.boolValue;
    __weak __typeof(UIButton *)weakLikeBtn = cell.likeBtn;
    [cell setLikeRequestBlock:^{
        [CommonRequests itemPreferenceRequestWithModel:item itemType:kItemAucationItem preferenceType:kPreferenceTypeLike viewController:self button:weakLikeBtn];
    }];
    
    
    __weak __typeof(UIButton *)weakCollectBtn = cell.collectBtn;
    weakCollectBtn.selected = item.collectType.boolValue;
    [cell setCollectRequestBlock:^{
        [CommonRequests itemPreferenceRequestWithModel:item itemType:kItemAucationItem preferenceType:kPreferenceTypeCollect viewController:self button:weakCollectBtn];
    }];
    
    
    if (self.aucationModel) {
        cell.countDownView.aucationState = self.aucationModel.status.intValue;
        cell.countDownView.itemState = item.status.intValue;
        cell.countDownView.startTime = item.starttime;
        [cell.countDownView refresh];
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 122.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //拍品详情
    AucationItemDetailViewController *vc = [[AucationItemDetailViewController alloc]init];
    vc.cid = [self.dataSourceArray[indexPath.row] cid];
    vc.shouldHideBottomView = self.shouldHideEnterHallBtn;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)enterHall
{
    AuctionHallViewController *vc = [[AuctionHallViewController alloc]init];
    vc.oid = self.aucationModel.oid;
    vc.agencyName = self.aucationModel.agencyName;
    vc.occasionName = self.aucationModel.occasionName;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}











-(UIView *)headerView
{
    if (!_tableHeaderView) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"SHeader" owner:nil options:nil];
        _tableHeaderView = (SessionHeader*)[nibContents objectAtIndex:0];
        
        __weak __typeof(self)weakself = self;
        _tableHeaderView.likeBlock = ^(UIButton *sender){
            [CommonRequests itemPreferenceRequestWithModel:weakself.aucationModel itemType:kItemSpecialPerformance preferenceType:kPreferenceTypeLike viewController:weakself button:sender];
        };
        
        _tableHeaderView.collectBlock = ^(UIButton *sender){
            [CommonRequests itemPreferenceRequestWithModel:weakself.aucationModel itemType:kItemSpecialPerformance preferenceType:kPreferenceTypeCollect viewController:weakself button:sender];
        };        
    }
    return _tableHeaderView;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.separatorColor = TableViewSeparateColor;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = [UIView backgroundView];
        _tableView.tableHeaderView = self.headerView;

        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestData];
        }];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, Screen_Width, 49)];
        _bottomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _bottomView.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"navigation"] stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
        [self.view addSubview:_bottomView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20, 7, Screen_Width - 40, 35);
        [btn addTarget:self action:@selector(enterHall) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:RedColor];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setTitle:@"正在拍卖 点击进入" forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        [_bottomView addSubview:btn];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 1 / [UIScreen mainScreen].scale)];
        line.backgroundColor = TableViewSeparateColor;
        [_bottomView addSubview:line];
    }
    return _bottomView;
}

@end
