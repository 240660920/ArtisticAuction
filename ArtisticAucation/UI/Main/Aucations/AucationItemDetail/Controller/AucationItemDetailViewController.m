//
//  AucationDetailViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/21.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationItemDetailViewController.h"
#import "AucationDetailTextCell.h"
#import "AucationDetailTopView.h"
#import "AucationItemDescriptionCell.h"
#import "NSString+PriceString.h"
#import "AgencyPerformancesViewController.h"
#import "AucationItemDetailResponse.h"
#import "BottomBidView.h"
#import "BidManager.h"
#import "AuctionHallViewController.h"
#import "WXApi.h"

@interface AucationItemDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    NSString *userNameForBid;
    NSString *phoneNumForBid;
}
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,assign)BOOL bidValid;
@property(nonatomic,strong)BottomBidView *bidView;
@property(nonatomic,strong)UIView *enterHallView; //进入拍场
@property(nonatomic,strong)UIView *positionFooterView;

@property(nonatomic,strong)LotResponse *item;

@end

@implementation AucationItemDetailViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"predisplayBidSuccess" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"拍品详情";
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 23, 23);
    [rightButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(predisplayBidSuccess:) name:@"predisplayBidSuccess" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
        ext.webpageUrl = [NSString stringWithFormat:@"%@%@?cid=%@",ServerUrl,@"Auction/detail2.html",self.cid];
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = [NSString stringWithFormat:@"%@",self.item.name];
        message.description = @"";
        [message setThumbImage:[UIImage imageNamed:@"icon"]];
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
        req.message = message;
        req.scene = scene;
        
        [WXApi sendReq:req];
    }
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)predisplayBidSuccess:(NSNotification *)notice
{
    NSDictionary *params = notice.object;
    NSString *price = params[@"price"];
    NSString *cid = params[@"cid"];
    
    if ([cid isEqualToString:self.item.cid]) {
        self.item.endprice = [price copy];
        [self.table reloadData];
    }
}

-(void)requestData
{
    [HttpManager requestWithAPI:@"company/queryOneCommodity" params:@{@"cid" : self.cid} requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
        
        [self.table.mj_header endRefreshing];
        
        AucationItemDetailResponse *response = [[AucationItemDetailResponse alloc]initWithString:request.responseString error:nil];
        
        self.item = response.data;

        if (self.item.status.intValue == DisplayTypePreDisplay) {
            self.bidView.hidden = NO;
            self.enterHallView.hidden = YES;
            
            self.table.tableFooterView = self.positionFooterView;
        }
        else if (self.item.status.intValue == DisplayTypeOngoing){
            self.enterHallView.hidden = NO;
            self.bidView.hidden = YES;
            
            self.table.tableFooterView = self.positionFooterView;
        }
        else{
            self.table.tableFooterView = nil;
            
            [self.bidView removeFromSuperview];
            [self.enterHallView removeFromSuperview];
        }
        
        
        self.bidView.itemCurrentPrice = self.item.endprice.intValue;
        
        [self.table reloadData];
        
    } failed:^(ASIFormDataRequest *request) {
        
        [self.table.mj_header endRefreshing];

        [self.view showHudAndAutoDismiss:NetworkErrorPrompt];
    }];
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [AucationDetailTopView heightForRowWithTitle:self.item.name];
    }
    else if (indexPath.row == 2){
        return [AucationItemDescriptionCell heightForText:[self.item.features componentsSeparatedByString:@";&"][0]];
    }
    else if (indexPath.row == 3){
        return [AucationItemDescriptionCell heightForText:[self.item.features componentsSeparatedByString:@";&"][1]];
    }
    else if (indexPath.row == 4){
        return [AucationItemDescriptionCell heightForText:[self.item.features componentsSeparatedByString:@";&"][2]];
    }
    else if (indexPath.row == 5){
        return [AucationItemDescriptionCell heightForText:self.item.desc];
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            AucationDetailTopView *view = [[AucationDetailTopView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, [AucationDetailTopView heightForRowWithTitle:self.item.name])];
            view.titleLabel.text = self.item.name;
            
            NSString *price = self.item.endprice.length == 0 ? self.item.startprice : self.item.endprice;
            
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithAttributedString:[NSString redPriceOfValue:price]];
            if (self.item.phoneNum && [[self.item.phoneNum componentsSeparatedByString:@"&"][0] isEqualToString:[UserInfo sharedInstance].phone]) {
                [attrString appendAttributedString:[[NSAttributedString alloc]initWithString:@" 自己" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0x1f/255.0 green:0x5e/255.0 blue:0x1f/255.0 alpha:1]}]];
            }
            
            
            view.priceLabel.attributedText = attrString;
            view.imageScrollView.imageUrls = self.item.images;
            [cell.contentView addSubview:view];
            
            view.subview.startPriceLabel.attributedText = [NSString blackPriceOfValue:self.item.startprice];

            /*委托出价*/
            if (self.item.status.intValue == DisplayTypePreDisplay) {
                view.subview.bidButton.hidden = NO;
            }
            else{
                view.subview.bidButton.hidden = YES;
            }

            NSString *myDelegatePrice = [self getMyBidPrice];
            view.subview.myBidLabel.attributedText = [NSString blackPriceOfValue:myDelegatePrice];
            
            NSString *bidType; //1是委托出价 2是预展出价
            if (self.item.phoneNum) {
                bidType = [[self.item.phoneNum componentsSeparatedByString:@"&"] lastObject];
            }
            
            //如果我的委托出价是目前最高价
            if (bidType.intValue == 1 && myDelegatePrice.intValue > 0 && self.item.phoneNum && [[self.item.phoneNum componentsSeparatedByString:@"&"][0] isEqualToString:[UserInfo sharedInstance].phone]) {
                view.subview.bidButton.enabled = NO;
                view.subview.bidButton.alpha = 0.6;
            }
            else{
                view.subview.bidButton.enabled = YES;
                view.subview.bidButton.alpha = 1;
            }
            /**/
            
            
            [view.subview setBidBlock:^{
                if ([UserInfo sharedInstance].loginType == kLoginTypePhone) {
                    phoneNumForBid = [UserInfo sharedInstance].phone;
                }
                else{
                    phoneNumForBid = [[NSUserDefaults standardUserDefaults]objectForKey:BidPhoneKey];
                }
                userNameForBid = [[NSUserDefaults standardUserDefaults]objectForKey:BidUsernameKey];
                
                if (phoneNumForBid.length > 0 && userNameForBid.length == 0) {
                    [self showNameAlert];
                }
                else if (phoneNumForBid.length == 0 && userNameForBid.length == 0){
                    [self showNameAndPhoneAlert];
                }
                else{
                    [self showBidAlert];
                }
            }];
            
            return cell;
        }
            break;
        case 1:
        {
            AucationDetailTextCell *cell = [[AucationDetailTextCell alloc]init];
            cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
            cell.leftLabel.text = @"送拍机构";
            cell.rightLabel.text = self.item.agencyName;
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_arrow"]];

            return cell;
        }
            break;
        case 2:
        {
            AucationItemDescriptionCell *cell = [[AucationItemDescriptionCell alloc]init];
            cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titlelabel.text = @"材质：";
            cell.contentLabel.text = self.item.features.length == 0 ? @"暂无" : [self.item.features componentsSeparatedByString:@";&"][0];
            return cell;
        }
            break;
        case 3:
        {
            AucationItemDescriptionCell *cell = [[AucationItemDescriptionCell alloc]init];
            cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titlelabel.text = @"尺寸：";
            cell.contentLabel.text = self.item.features.length == 0 ? @"暂无" : [self.item.features componentsSeparatedByString:@";&"][1];
            return cell;
        }
            break;
        case 4:
        {
            AucationItemDescriptionCell *cell = [[AucationItemDescriptionCell alloc]init];
            cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titlelabel.text = @"作者及简介：";
            cell.contentLabel.text = self.item.features.length == 0 ? @"暂无" : [self.item.features componentsSeparatedByString:@";&"][2];
            return cell;
        }
            break;
        case 5:{
            AucationItemDescriptionCell *cell = [[AucationItemDescriptionCell alloc]init];
            cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titlelabel.text = @"拍品赏析：";
            cell.contentLabel.text = self.item.desc.length == 0 ? @"暂无" : self.item.desc;
            
            return cell;
        }
            break;
        case 6:
        {
            AucationDetailTextCell *cell = [[AucationDetailTextCell alloc]init];
            cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
            cell.leftLabel.text = @"服务保障";
            cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right_arrow"]];
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1 && self.item.agencyName.length > 0) {
        AgencyPerformancesViewController *vc = [[AgencyPerformancesViewController alloc]init];
        vc.agencyId = self.item.aid;
        vc.agencyName = self.item.agencyName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)enterHall
{
    AuctionHallViewController *vc = [[AuctionHallViewController alloc]init];
    vc.oid = self.item.oid;
    vc.agencyName = self.item.agencyName;
    vc.occasionName = self.item.occasion.occasionName;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showNameAlert
{
    UIAlertView *nameAlert = [[UIAlertView alloc]initWithTitle:@"请输入姓名" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    nameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [nameAlert show];
    [nameAlert handleClickedButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1 && [nameAlert textFieldAtIndex:0].text.length > 0) {
            userNameForBid = [nameAlert textFieldAtIndex:0].text;

            [self showBidAlert];
            
            [[NSUserDefaults standardUserDefaults]setObject:userNameForBid forKey:BidUsernameKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }];
}

-(void)showNameAndPhoneAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入姓名和手机号码" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert textFieldAtIndex:0].placeholder = @"请输入姓名";
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeDecimalPad;
    [alert textFieldAtIndex:1].keyboardType = UIKeyboardTypePhonePad;
    [alert textFieldAtIndex:1].placeholder = @"请输入手机号码";
    [alert textFieldAtIndex:1].secureTextEntry = NO;
    [alert show];
    
    [alert handleClickedButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            userNameForBid = [alert textFieldAtIndex:0].text;
            phoneNumForBid = [alert textFieldAtIndex:1].text;
            [self showBidAlert];
            
            [[NSUserDefaults standardUserDefaults]setObject:userNameForBid forKey:BidUsernameKey];
            [[NSUserDefaults standardUserDefaults]setObject:phoneNumForBid forKey:BidPhoneKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }];
}

-(void)showBidAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入金额" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].placeholder = @"请输入金额";
    
    [alert show];
    
    [alert handleClickedButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self bid:[alert textFieldAtIndex:0].text phone:phoneNumForBid];
        }
    }];
}

//委托出价
-(void)bid:(NSString *)price phone:(NSString *)phone
{
    NSString *currentPrice = self.item.endprice.length == 0 ? self.item.startprice : self.item.endprice;

    
   if (price.length == 0){
        [self.view showHudAndAutoDismiss:@"请输入金额"];
        return;
    }
   else if (price.intValue <= currentPrice.intValue){
       [self.view showHudAndAutoDismiss:@"金额必须高于当前价格"];
       return;
   }
    
    NSString *regex = @"^[1][3578][0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![predicate evaluateWithObject:[phone stringByReplacingOccurrencesOfString:@"-" withString:@""]] || phone.length == 0) {
        [self.view showHudAndAutoDismiss:@"请输入正确的手机号码"];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"cid"] = self.item.cid;
    params[@"phone"] = phone;
    params[@"price"] = price;
    params[@"username"] = userNameForBid;
    if ([UserInfo sharedInstance].userId.length > 0) {
        params[@"userid"] = [UserInfo sharedInstance].userId;
    }
    
    [HttpManager requestWithAPI:@"company/userRaisePrice" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
        
        NSDictionary *rstDic = [request.responseString objectFromJSONString];
        if (rstDic[@"result"] && [rstDic[@"result"][@"resultCode"]intValue] == 0) {
            [self.view showHudAndAutoDismiss:@"出价成功"];
            
            [self saveMyBidPrice:price];
            
            [self.table reloadData];
            
            [self requestData];
        }
        else{
            [self.view showHudAndAutoDismiss:@"出价失败"];
        }
        
    } failed:^(ASIFormDataRequest *request) {
        [self.view showHudAndAutoDismiss:NetworkErrorPrompt];
    }];
}

-(void)saveMyBidPrice:(NSString *)priceValue
{
    NSString *key = [NSString stringWithFormat:@"userid=%@&oid=%@&cid=%@",[UserInfo sharedInstance].userId,self.item.oid,self.item.cid];
    [[NSUserDefaults standardUserDefaults]setObject:priceValue forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.table reloadData];
}

-(NSString *)getMyBidPrice
{
    NSString *key = [NSString stringWithFormat:@"userid=%@&oid=%@&cid=%@",[UserInfo sharedInstance].userId,self.item.oid,self.item.cid];
    NSString *value = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    if (!value) {
        value = @"0";
    }
    return value;
}

#pragma mark properties
-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundView = [UIView backgroundView];
        _table.separatorColor = TableViewSeparateColor;
        _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self requestData];
        }];
        
        if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
            [_table setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
            [_table setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self.view addSubview:_table];
    }
    return _table;
}

-(BottomBidView *)bidView
{
    if (!_bidView && !self.shouldHideBottomView) {
        _bidView = [[BottomBidView alloc]init];
        _bidView.delegate = self;
        _bidView.frame = CGRectMake(0, self.view.frame.size.height - BottomBidViewHeight, Screen_Width, BottomBidViewHeight);
        _bidView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.view insertSubview:_bidView aboveSubview:self.table];
        
        __weak __typeof(self)weakself = self;
        [_bidView setBidBlock:^(NSString *price) {
            [[BidManager sharedInstance]preDisplayBid:price oid:weakself.item.oid cid:weakself.item.cid];
        }];
        
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 1 / [UIScreen mainScreen].scale)];
        line.backgroundColor = TableViewSeparateColor;
        [_bidView addSubview:line];
    }
    return _bidView;
}


-(UIView *)enterHallView
{
    if (!_enterHallView && !self.shouldHideBottomView) {
        _enterHallView = [[UIView alloc]init];
        _enterHallView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        [self.view insertSubview:_enterHallView aboveSubview:self.table];
        
        [_enterHallView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.equalTo(@(BottomBidViewHeight));
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(enterHall) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:RedColor];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setTitle:@"正在拍卖 点击进入" forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5;
        [_enterHallView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_enterHallView).offset(-40);
            make.centerX.centerY.equalTo(_enterHallView);
            make.height.equalTo(@35);
        }];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 1 / [UIScreen mainScreen].scale)];
        line.backgroundColor = TableViewSeparateColor;
        [_enterHallView addSubview:line];
    }
    return _enterHallView;
}

-(UIView *)positionFooterView
{
    if (!_positionFooterView && !self.shouldHideBottomView) {
        _positionFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, BottomBidViewHeight)];
        _positionFooterView.backgroundColor = [UIColor clearColor];
    }
    return _positionFooterView;
}


@end
