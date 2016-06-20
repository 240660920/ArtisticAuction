//
//  SearchViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/11.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "SearchViewController.h"
#import "FMUString.h"
#import "CommonRequests.h"
#import "AucationItemsListResponse.h"
#import "AucationItemDetailViewController.h"
#import "AucationItemCell.h"
#import "EightProModel.h"
#import "ThreeProModel.h"
#import "SearchResultModel.h"

NSString * const RecommendRequestNotification = @"RecommendRequestNotification";

@interface SearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_searchBgView;
    UITextField *_txfSearchField;
    
    UIButton *_cancelBut;
    
    NSString *_searchType;
    NSString *_searchState;
    KSearchType ksType;
}
@property(nonatomic,retain)NSMutableArray *recommendDataArray;  //推荐列表结果
@property(nonatomic,retain)NSMutableArray *dataArray;           //搜索结果

@property(nonatomic,retain)NSMutableArray *stateArray;  //3项 用于多选参数拼凑
@property(nonatomic,retain)NSMutableArray *keyArray;    //type关键词归结 用于多选参数拼凑
@end

@implementation SearchViewController

-(void)itemPreferenceStateChanged:(NSNotification *)notice
{
    NSDictionary *dic = notice.object;
    
    NSString *itemId = dic[@"itemId"];
    NSString *itemType = dic[@"itemType"];
    NSString *state = dic[@"state"];
    NSString *count = dic[@"count"];
    NSString *preferenceType = dic[@"preferenceType"];
    
    [self.recommendDataArray enumerateObjectsUsingBlock:^(LotResponse *obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    
    [self.dataArray enumerateObjectsUsingBlock:^(LotResponse *obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

//三项状态
-(IBAction)actionPreviewIngOver:(UIButton *)sender
{
    ThreeProModel *m = [_stateArray objectAtIndex:sender.tag -1];
    m.isSelected = !sender.selected;
    sender.selected = m.isSelected;
}

-(NSString *)getState
{
    _searchState = @"";
    [_stateArray enumerateObjectsUsingBlock:^(ThreeProModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        if(obj.isSelected)
        {
            if([_searchState isEqualToString:@""])
            {
                _searchState = obj.name;
            }
            else
            {
                _searchState = [NSString stringWithFormat:@"%@;%@",_searchState,obj.name];
            }
        }
    }];
    return _searchState;
}

//三项状态清空
-(void)unSelectForStatus
{
    [_stateArray enumerateObjectsUsingBlock:^(ThreeProModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        obj.isSelected = NO;
    }];
    _previewBut.selected = NO;
    _ingBut.selected = NO;
    _overBut.selected = NO;
    _searchState = @"";
}

//八项状态
-(IBAction)actionStairCatalog:(UIButton *)sender
{
    EightProModel *m = [_keyArray objectAtIndex:sender.tag -1];
    m.isSelected = !sender.selected;
    sender.selected = m.isSelected;
}

-(NSString *)getType
{
    _searchType = @"";
    [_keyArray enumerateObjectsUsingBlock:^(EightProModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        if(obj.isSelected)
        {
            if([_searchType isEqualToString:@""])
            {
                _searchType = obj.name;
            }
            else
            {
                _searchType = [NSString stringWithFormat:@"%@;%@",_searchType,obj.name];
            }
        }
    }];
    return _searchType;
}

//八项状态清空
-(void)unSelectForTypeBut
{
    [_keyArray enumerateObjectsUsingBlock:^(EightProModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //
        obj.isSelected = NO;
    }];
    _smjkBut.selected = NO;
    _xhdsBut.selected = NO;
    _yqzbBut.selected = NO;
    _zstcBut.selected = NO;
    _wwscBut.selected = NO;
    _sgypBut.selected = NO;
    _cjzbBut.selected = NO;
    _zxBut.selected = NO;
    _searchType = @"";
}

-(void)initEightPro
{
    [_keyArray removeAllObjects];
    for (int i = 0 ; i<8; i++) {
        EightProModel *model = [[EightProModel alloc] init];
        model.isSelected = NO;
        switch (i) {
            case 0:
            {
                model.name = @"书画";
            }
                break;
            case 1:
            {
                model.name = @"玉器";
            }
                break;
            case 2:
            {
                model.name = @"陶瓷";
            }
                break;
            case 3:
            {
                model.name = @"紫砂";
            }
                break;
            case 4:
            {
                model.name = @"珠宝";
            }
                break;
            case 5:
            {
                model.name = @"茶叶";
            }
                break;
            case 6:
            {
                model.name = @"老酒";
            }
                break;
            case 7:
            {
                model.name = @"杂项";
            }
                break;
                
            default:
                break;
        }
        [_keyArray addObject:model];
    }
}

-(void)initThreePro
{
    [_stateArray removeAllObjects];
    for (int i = 0 ; i<3; i++) {
        ThreeProModel *model = [[ThreeProModel alloc] init];
        model.isSelected = NO;
        switch (i) {
            case 0:
            {
                model.name = @"0";   //未开始
            }
                break;
            case 1:
            {
                model.name = @"1";   //进行中
            }
                break;
            case 2:
            {
                model.name = @"2;3"; //结束
            }
                break;
                
            default:
                break;
        }
        [_stateArray addObject:model];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if(ksType == kSearchTypeRecommend)
    {
        [self noFocusNavgation];
    }
}

//推荐列表状态
-(void)noFocusNavgation
{
    _cancelBut.hidden = YES;
    self.navigationItem.titleView = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    UIImage *image = [UIImage imageNamed:@"search_bg"];
    _searchBgView.frame = CGRectMake(10, 10, self.view.bounds.size.width-20, image.size.height);
    _searchBgView.image = [image stretchableImageWithLeftCapWidth:30 topCapHeight:5];
    self.navigationItem.titleView = _searchBgView;
    
    if(iPhone5Screen || iPhone4Screen)
    {
        _txfSearchField.frame = CGRectMake(30, 0, self.view.bounds.size.width - 50 - 50, image.size.height);
    }
    else
    {
        _txfSearchField.frame = CGRectMake(30, 0, self.view.bounds.size.width - 50, image.size.height);
    }
}

//搜索状态
-(void)focusNavgation
{
    [self setStatusButton];
    
    _cancelBut.hidden = NO;
    self.navigationItem.titleView = nil;
    self.navigationItem.rightBarButtonItem = nil;
    _cancelBut.frame = CGRectMake(0, 0, 40, 30);
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_cancelBut];
    self.navigationItem.rightBarButtonItem = backItem;
    
    UIImage *image = [UIImage imageNamed:@"search_bg"];
    _searchBgView.frame = CGRectMake(10, 10, self.view.bounds.size.width -20 - 50, image.size.height);
    _searchBgView.image = [image stretchableImageWithLeftCapWidth:30 topCapHeight:0];
    self.navigationItem.titleView = _searchBgView;
    
    _txfSearchField.frame = CGRectMake(30, 0, self.view.bounds.size.width - 50 - 50, image.size.height);
}

-(void)setStatusButton
{
    self.previewBut.frame = CGRectMake(30, 25, (self.view.bounds.size.width-60)/3, 29);
    self.overBut.frame = CGRectMake(CGRectGetMaxX(self.previewBut.frame), 25, (self.view.bounds.size.width-60)/3, 29);
    self.ingBut.frame = CGRectMake(CGRectGetMaxX(self.overBut.frame), 25, (self.view.bounds.size.width-60)/3, 29);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestForRecommend) name:RecommendRequestNotification object:nil];
    
    ksType = kSearchTypeRecommend;
    
    _recommendDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _keyArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self initEightPro];
    _stateArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self initThreePro];
    
    self.navigationItem.leftBarButtonItems = nil;
    _searchState = @"";
    _searchType = @"";
    
    UIImage *image = [UIImage imageNamed:@"search_bg"];
    _searchBgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, image.size.height)];
    _searchBgView.image = [image stretchableImageWithLeftCapWidth:30 topCapHeight:5];
    _searchBgView.userInteractionEnabled = YES;
    self.navigationItem.titleView = _searchBgView;
    
    _txfSearchField = [[UITextField alloc] init];
    _txfSearchField.backgroundColor = [UIColor clearColor];
    _txfSearchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _txfSearchField.textColor = ColorRGBA(51, 51, 51, 1.0);
    _txfSearchField.borderStyle = UITextBorderStyleNone;
    _txfSearchField.placeholder = @"搜索";
    _txfSearchField.font = [UIFont systemFontOfSize:14];
    _txfSearchField.delegate = self;
    _txfSearchField.returnKeyType = UIReturnKeySearch;
    [_searchBgView addSubview:_txfSearchField];
    
    _cancelBut = [[UIButton alloc] init];
    [_cancelBut setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBut setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_cancelBut setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255.0/255.0 alpha:0.6] forState:UIControlStateHighlighted];
    [_cancelBut setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255.0/255.0 alpha:0.4] forState:UIControlStateDisabled];
    _cancelBut.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    _cancelBut.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [_cancelBut addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBut.frame = CGRectMake(0, 0, 40, 30);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_cancelBut];
    self.navigationItem.rightBarButtonItem = backItem;
    
    [self.previewBut setBackgroundImage:[[UIImage imageNamed:@"search_state_left"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [self.previewBut setBackgroundImage:[[UIImage imageNamed:@"search_state_left_s"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateSelected];
    
    [self.overBut setBackgroundImage:[[UIImage imageNamed:@"search_state_mid"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [self.overBut setBackgroundImage:[[UIImage imageNamed:@"search_state_mid_s"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateSelected];
    
    [self.ingBut setBackgroundImage:[[UIImage imageNamed:@"search_state_right"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [self.ingBut setBackgroundImage:[[UIImage imageNamed:@"search_state_right_s"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateSelected];
    
    [self.scrller setContentSize:CGSizeMake(self.view.bounds.size.width, 145*4 + 50)];
    
    [self.sureBut setBackgroundImage:[[UIImage imageNamed:@"red_button_nor"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    
    self.tableView.backgroundView = [UIView backgroundView];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionHideKeyboard:)];
    [self.scrller addGestureRecognizer:tap];
    
    [self requestForRecommend];
    self.tableView.hidden = NO;
    self.scrller.hidden = YES;
}

-(void)actionHideKeyboard:(UITapGestureRecognizer *)ges
{
    if([_txfSearchField isFirstResponder])
    {
        [_txfSearchField resignFirstResponder];
    }
}

//执行搜索 + 参数整理
-(IBAction)actionSearch:(UIButton *)sender
{
    SearchKeyType typ = 0;
    if([FMUString isEmptyString:_txfSearchField.text])
    {
        //没有关键字  区分是status 还是type
        if(_searchType.length > 0)
        {
            typ = kType_type;
        }
        else
        {
            typ = kType_status;
        }
    }
    else
    {
        typ = kType_condition;
    }
    
    //参数组织
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    int cutNum = 0;
    if(_txfSearchField.text.length > 0)
    {
        [dic setObject:_txfSearchField.text forKey:@"condition"];
    }
    else
    {
        cutNum = cutNum + 1;
    }
    if([[self getState] length] > 0)
    {
        [dic setObject:[self getState] forKey:@"status"];
    }
    else
    {
        cutNum = cutNum + 1;
    }
    if([[self getType] length] > 0)
    {
        [dic setObject:[self getType] forKey:@"type"];
    }
    else
    {
        cutNum = cutNum + 1;
    }
    NSLog(@"%@ - %@ - %@",_txfSearchField.text,[self getState],_searchType);
    
    if(cutNum == 3)
    {
        [_txfSearchField resignFirstResponder];
        return;
    }
    
    if([UserInfo sharedInstance].userId && [UserInfo sharedInstance].userId.length > 0)
    {
        [dic setObject:[UserInfo sharedInstance].userId forKey:@"userid"];
        [self requestForSearchWithParams:dic];
    }
    else
    {
        [self requestForSearchWithParams:dic];
    }
    
    [_txfSearchField resignFirstResponder];
    _txfSearchField.text =@"";
    [self unSelectForStatus];
    [self unSelectForTypeBut];
}

-(void)actionCancel:(UIButton *)sender
{
    ksType = kSearchTypeRecommend;
    [self noFocusNavgation];
    [_txfSearchField resignFirstResponder];
    _txfSearchField.text =@"";
    [self unSelectForStatus];
    [self unSelectForTypeBut];
    self.tableView.hidden = NO;
    self.scrller.hidden = YES;
    [self.tableView reloadData];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self actionSearch:nil];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self focusNavgation];
    self.tableView.hidden = YES;
    self.scrller.hidden = NO;
    return YES;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(ksType == kSearchTypeRecommend)
    {
        return self.recommendDataArray.count;
    }
    else
    {
        return self.dataArray.count;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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
    
    LotResponse *item = nil;
    if(ksType == kSearchTypeRecommend)
    {
        item = _recommendDataArray[indexPath.row];
    }
    else
    {
        item = self.dataArray[indexPath.row];
    }

    if (item.images.count > 0) {
        [cell.picImageV sd_setImageWithURL:[NSURL URLWithString:[item.images[0] completeImageUrlString]] placeholderImage:AucationItem_PlaceHolderImage];
    }
    else{
        cell.picImageV.image = AucationItem_PlaceHolderImage;
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
    
    
    cell.countDownView.aucationState = DisplayTypeNone;
    cell.countDownView.itemState = item.status.intValue;
    cell.countDownView.startTime = item.starttime;
    [cell.countDownView refresh];

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 122.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AucationItemDetailViewController *vc = [[AucationItemDetailViewController alloc]init];
    if(ksType == kSearchTypeRecommend)
    {
        vc.cid = [_recommendDataArray[indexPath.row]cid];
    }
    else
    {
        vc.cid = [self.dataArray[indexPath.row]cid];
    }
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - HTTP
//推荐列表
-(void)requestForRecommend
{
    [self.view showLoadingHud];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if ([UserInfo sharedInstance].loginType != kLoginTypeTraveller) {
        params[@"userid"] = [UserInfo sharedInstance].userId;
    }
    [HttpManager requestWithAPI:@"company/getRecommendCommdity" params:params requestMethod:@"GET" completion:^(ASIFormDataRequest *request) {
        [self.view hideAllHud];
        
        SearchResultModel *response = [[SearchResultModel alloc]initWithString:request.responseString error:nil];
        if (!_recommendDataArray) {
            _recommendDataArray = [[NSMutableArray alloc]init];
        }
        [_recommendDataArray removeAllObjects];
        [_recommendDataArray addObjectsFromArray:response.data];
   
        //排序
        [_recommendDataArray sortUsingComparator:^NSComparisonResult(LotResponse *obj1, LotResponse *obj2) {
            if (obj1.collectTotals.intValue > obj2.collectTotals.intValue) {
                return NSOrderedAscending;
            }
            else if (obj1.collectTotals.intValue == obj2.collectTotals.intValue){
                if (obj1.likeTotals.intValue > obj2.likeTotals.intValue) {
                    return NSOrderedAscending;
                }
                else if (obj1.likeTotals.intValue < obj2.likeTotals.intValue){
                    return NSOrderedDescending;
                }
                return NSOrderedSame;
            }
            else{
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
        
        
        [self.tableView reloadData];
        
    } failed:^(ASIFormDataRequest *request) {
        [self.view hideAllHud];
        [self.view showHudAndAutoDismiss:NetworkErrorPrompt];
    }];
}

//搜索结果列表
-(void)requestForSearchWithParams:(NSDictionary *)dic
{
    ksType = kSearchTypeKeyWord;
    
    [self.view showLoadingHud];
    [HttpManager requestWithAPI:@"company/searchCommodity" params:dic requestMethod:@"GET" completion:^(ASIFormDataRequest *request) {
        [self.view hideAllHud];
        self.tableView.hidden = NO;
        self.scrller.hidden = YES;
        
        SearchResultModel *response = [[SearchResultModel alloc]initWithString:request.responseString error:nil];
        if (!_dataArray) {
            _dataArray = [[NSMutableArray alloc]init];
        }
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:response.data];
        
        [self.tableView reloadData];
        
    } failed:^(ASIFormDataRequest *request) {
        [self.view hideAllHud];
        [self.view showHudAndAutoDismiss:NetworkErrorPrompt];
    }];
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
