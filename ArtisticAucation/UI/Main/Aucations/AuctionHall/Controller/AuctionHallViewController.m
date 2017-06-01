//
//  AuctionHallViewController.m
//  ArtisticAuction
//
//  Created by xieran on 2017/4/25.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallViewController.h"
#import "AucationItemDetailViewController.h"
#import "AucationItemsListViewController.h"
#import "AAImagesScrollView.h"
#import "AuctionHallStateView.h"
#import "AuctionHallTitleView.h"
#import "AuctionHallInputView.h"
#import "AuctionHallCurrentItemModel.h"
#import "AuctionHallCellViewModel.h"
#import "AuctionHallTableViewCell.h"
#import "NSMutableArray+AddHallViewModel.h"
#import "AuctionHallCountDownView.h"
#import "BidManager.h"
#import "AuctionHallItemIntroTimer.h"
#import <MQTTClient/MQTTClient.h>

@interface AuctionHallViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MQTTSessionDelegate>

@property(nonatomic,strong)AuctionHallTitleView *titleView;
@property(nonatomic,strong)AuctionHallStateView *stateView;
@property(nonatomic,strong)AuctionHallInputView *bottomView;
@property(nonatomic,strong)AuctionHallCountDownView *countDownView;

@property(nonatomic,strong)AuctionHallItemIntroTimer *itemIntroTimer;

@property(nonatomic,strong)AuctionHallCurrentItemModel *itemModel;

@property(nonatomic,strong)MQTTSession *mqttSession;

@property(nonatomic,strong)AAImagesScrollView *imgScrollView;
@property(nonatomic,strong)UITableView *table;

@property(nonatomic,strong)NSMutableArray *viewModels;

@end

@implementation AuctionHallViewController

-(void)dealloc
{
    [self.mqttSession removeObserver:self forKeyPath:@"status"];
    
    [self.mqttSession disconnect];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation"]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

    
    self.titleView.occasionLabel.text = self.occasionName;
    self.titleView.agencyLabel.text = self.agencyName;
    
    
    _viewModels = [[NSMutableArray alloc]init];
    



    [self configAutoLayout];
    
    
    [self enterHall];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)configAutoLayout
{
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    
    [self.imgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
        make.height.equalTo(@(Screen_Width - 100));
    }];
    
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.imgScrollView.mas_bottom);
        make.height.equalTo(@55);
    }];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.stateView.mas_bottom);
        make.bottom.equalTo(self.view).offset(-44);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    [self.countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imgScrollView);
    }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.bottomView isFirstResponder]) {
        [self.bottomView resignFirstResponder];
    }
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AuctionHallCellViewModel *viewModel = self.viewModels[indexPath.row];
    
    NSString *identifier = [viewModel identifier];
    AuctionHallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[viewModel cellClass] alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    [cell setViewModel:viewModel];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AuctionHallCellViewModel *viewModel = self.viewModels[indexPath.row];
    return [viewModel cellHeight];
}

-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma private methods

-(void)enterHall
{
    NSString *guid = [UserInfo sharedInstance].guid;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"oid"] = self.oid;
    if (guid) {
        params[@"guid"] = guid;
    }
    
    [HttpManager requestWithAPI:@"user/userEnterLobby" params:params requestMethod:@"GET" completion:^(ASIFormDataRequest *request) {

        AABaseJSONModelResponse *rsp = [[AABaseJSONModelResponse alloc]initWithString:request.responseString error:nil];
        
        //成功
        if (rsp.result.resultCode.intValue == 0) {
            [self mqttConnect];
        }
        //失败
        else{
            [self.view showHudAndAutoDismiss:rsp.result.msg];
        }
    
    } failed:^(ASIFormDataRequest *request) {
        [self.view showHudAndAutoDismiss:@"连接失败"];
    }];
}

-(void)mqttConnect
{
    // 创建一个传输对象
    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
    transport.host = IP_Address;
    transport.port = 61613;

    self.mqttSession = [[MQTTSession alloc] init];
    self.mqttSession.transport = transport;
    self.mqttSession.delegate = self;
    // 设置终端ID(可以根据后台的详细详情进行设置)
    self.mqttSession.clientId = [UserInfo sharedInstance].guid;
    [self.mqttSession setUserName:@"admin"];
    [self.mqttSession setPassword:@"password"];
    

    [self.mqttSession addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 会话链接并设置超时时间
        MQTTConnectHandler hanlder = ^(NSError *error){
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view showHudAndAutoDismiss:error.description];
                });
            }
        };
        [self.mqttSession setConnectHandler:hanlder];
        [self.mqttSession connectAndWaitTimeout:30];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 订阅主题, qosLevel是一个枚举值,指的是消息的发布质量
            // 注意:订阅主题不能放到子线程进行,否则block不会回调
            [self.mqttSession subscribeToTopic:self.oid atLevel:MQTTQosLevelAtMostOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
                if (error) {
                    NSLog(@"连接失败 = %@", error.localizedDescription);
                }else{
                    NSLog(@"链接成功 = %@", gQoss);
                }
            }];
        });
    });
}

- (void)newMessage:(MQTTSession *)session
              data:(NSData *)data
           onTopic:(NSString *)topic
               qos:(MQTTQosLevel)qos
          retained:(BOOL)retained
               mid:(unsigned int)mid
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *str = [[NSString alloc] initWithData:data encoding:encoding];
    
    NSLog(@"--------%@",str);
    
    MQTTMessageBaseModel *model = [[MQTTMessageBaseModel alloc]initWithString:str error:nil];
    
    switch (model.typeEnum) {
        //拍品信息
        case kMQTTMessageTypeItem:{
            AuctionHallCurrentItemModel *itemModel = [[AuctionHallCurrentItemModel alloc]initWithString:str error:nil];
            
            self.itemModel = itemModel;
            
            //图片
            [self.imgScrollView setImageUrls:itemModel.data.image];
            
            //名称
            self.stateView.nameLabel.text = itemModel.data.cname;
            
            //开始推拍品介绍
            self.itemIntroTimer.model = itemModel;
            
            if ([itemModel.data.phone isEqualToString:[BidManager sharedInstance].phone]) {
                self.stateView.priceLabel.text = [NSString stringWithFormat:@"¥%.0f(自己)",itemModel.data.endprice.floatValue];
            }
            else{
                self.stateView.priceLabel.text = [NSString stringWithFormat:@"¥%.0f",itemModel.data.endprice.floatValue];
            }
            self.bottomView.startPrice = [itemModel.data.endprice copy];

        }
            break;
        //出价
        case kMQTTMessageTypeBid:{
            AuctionHallBidModel *bidModel = [[AuctionHallBidModel alloc]initWithString:str error:nil];
            
            AuctionHallBidViewModel *bidViewModel = [[AuctionHallBidViewModel alloc]init];
            bidViewModel.dataModel = bidModel;
            [self.viewModels addViewModel:bidViewModel];
            
            [self.table reloadData];
            [self.table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
            
            if ([bidModel.phone isEqualToString:[BidManager sharedInstance].phone]) {
                self.stateView.priceLabel.text = [NSString stringWithFormat:@"¥%.0f(自己)",bidModel.price.floatValue];
            }
            else{
                self.stateView.priceLabel.text = [NSString stringWithFormat:@"¥%.0f",bidModel.price.floatValue];
            }
            self.bottomView.startPrice = bidModel.price;
            
            
            self.itemModel.data.phone = bidModel.phone;
            
            [self.countDownView stop];

        }
            break;
        //成交
        case kMQTTMessageTypeDeal:{
            AuctionHallSystemModel *sysModel = [[AuctionHallSystemModel alloc]initWithString:str error:nil];
            
            AuctionHallSystemViewModel *viewModel = [[AuctionHallSystemViewModel alloc]init];
            viewModel.dataModel = sysModel;
            [self.viewModels addViewModel:viewModel];
            
            [self.table reloadData];
            [self.table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
            
            
            //中断倒计时
            [self.countDownView stop];

        }
            break;
        //聊天
        case kMQTTMessageTypeChat:{
            AuctionHallChatModel *chatModel = [[AuctionHallChatModel alloc]initWithString:str error:nil];
            
            AuctionHallChatViewModel *viewModel = [[AuctionHallChatViewModel alloc]init];
            viewModel.dataModel = chatModel;
            [self.viewModels addViewModel:viewModel];
            
            [self.table reloadData];
            [self.table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];

        }
            break;
        //倒计时
        case kMQTTMessageTypeCountDown:
            //开始倒计时
            [self.countDownView showWithSecond:10];
            break;
        default:
            break;
    }
}

-(void)bid:(NSString *)price
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"userid"] = [UserInfo sharedInstance].userId;
    params[@"cid"] = self.itemModel.data.cid;
    params[@"phone"] = [BidManager sharedInstance].phone;
    params[@"username"] = [BidManager sharedInstance].userName;
    params[@"price"] = [price copy];
    
    [HttpManager requestWithAPI:@"company/userBid" params:params requestMethod:@"GET" completion:^(ASIFormDataRequest *request) {
       
        AABaseJSONModelResponse *rsp = [[AABaseJSONModelResponse alloc]initWithString:request.responseString error:nil];
        if (rsp.result.resultCode.intValue == 0) {
            

        }
        else{
            [self.view showHudAndAutoDismiss:@"出价失败"];
        }
        
    } failed:^(ASIFormDataRequest *request) {
        [self.view showHudAndAutoDismiss:@"出价失败"];
    }];
}

-(void)sendChatContent:(NSString *)chatContent
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"userid"] = [UserInfo sharedInstance].userId;
    params[@"cid"] = self.itemModel.data.cid;
    params[@"message"] = chatContent;
    params[@"phone"] = [BidManager sharedInstance].phone;
    
    
    [HttpManager requestWithAPI:@"user/userSendMessage" params:params requestMethod:@"GET" completion:^(ASIFormDataRequest *request) {
        
        AABaseJSONModelResponse *rsp = [[AABaseJSONModelResponse alloc]initWithString:request.responseString error:nil];
        if (rsp.result.resultCode.intValue == 0) {
            NSLog(@"发生成功");
        }
        else{
            [self.view showHudAndAutoDismiss:@"发送失败"];
        }
        
    } failed:^(ASIFormDataRequest *request) {
        [self.view showHudAndAutoDismiss:@"发送失败"];
    }];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.mqttSession) {
        switch (self.mqttSession.status) {
            case MQTTSessionStatusConnecting:
                self.titleView.occasionLabel.text = [NSString stringWithFormat:@"%@(连接中...)",self.occasionName];
                break;
            case MQTTSessionStatusConnected:
                self.titleView.occasionLabel.text = self.occasionName;
                break;
            case MQTTSessionStatusClosed:
            case MQTTSessionStatusError:
                self.titleView.occasionLabel.text = [NSString stringWithFormat:@"%@(未连接)",self.occasionName];
                break;
            default:
                break;
        }
    }
}





-(void)tapImgView
{
    if (self.itemModel.data.cid) {
        AucationItemDetailViewController *vc = [[AucationItemDetailViewController alloc]init];
        vc.cid = self.itemModel.data.cid;
        vc.shouldHideBottomView = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)enterItemList
{
    AucationItemsListViewController *vc = [[AucationItemsListViewController alloc]init];
    vc.oid = self.oid;
    vc.shouldHideEnterHallBtn = YES; //隐藏进入拍场的按钮
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)keyboardFrameWillChange:(NSNotification *)notice
{
    NSDictionary *userInfo = notice.userInfo;
    
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:7];
    [UIView setAnimationDuration:duration];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(keyboardFrame.origin.y == Screen_Height ? 0 : -keyboardFrame.size.height);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
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

-(AuctionHallTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[NSBundle mainBundle]loadNibNamed:@"AuctionHallTitleView" owner:nil options:nil][0];
        [self.view addSubview:_titleView];
        
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"white_left_arrow_nor"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        [_titleView addSubview:backBtn];
        
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleView).offset(18);
            make.width.height.equalTo(@23);
            make.centerY.equalTo(_titleView).offset(10);
        }];
    }
    return _titleView;
}

-(AuctionHallStateView *)stateView
{
    if (!_stateView) {
        _stateView = [[NSBundle mainBundle]loadNibNamed:@"AuctionHallStateView" owner:nil options:nil][0];
        [self.view addSubview:_stateView];
        
        __weak __typeof(self)weakself = self;
        [_stateView setTapItemListBlock:^{
            [weakself enterItemList];
        }];
    }
    return _stateView;
}

-(AuctionHallInputView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle]loadNibNamed:@"AuctionHallInputView" owner:nil options:nil][0];
        [self.view addSubview:_bottomView];
        
        WS(weakSelf);
        [_bottomView setBidBlock:^(NSString *price){
            if ([weakSelf.itemModel.data.phone isEqualToString:[BidManager sharedInstance].phone]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"当前最高价格已是自己保持\n确认继续出价？" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                [alert handleClickedButton:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [weakSelf bid:price];
                    }
                }];
            }
            else{
                [weakSelf bid:price];
            }
        }];
        
        [_bottomView setSendChatBlock:^(NSString *chatContent){
            [weakSelf sendChatContent:chatContent];
        }];
        

        
        [_bottomView setShouldBeginEditingBlock:^BOOL{
            if (![BidManager sharedInstance].phone ||
                ![BidManager sharedInstance].userName) {
                
                if ([UserInfo sharedInstance].loginType == kLoginTypeTraveller) {
                    [weakSelf.view showHudAndAutoDismiss:@"请先登录"];
                }
                else{
                    [[BidManager sharedInstance]showInputNameAndPhoneAlert];
                }
                
                return NO;
            }
            return YES;
        }];
    }
    return _bottomView;
}

-(AAImagesScrollView *)imgScrollView
{
    if (!_imgScrollView) {
        _imgScrollView = [[AAImagesScrollView alloc]init];
        [self.view addSubview:_imgScrollView];

        __weak __typeof(self)weakself = self;
        [_imgScrollView setTapBlock:^(NSArray *imgUrls, NSInteger currentIndex, id dataModel) {
            __strong __typeof(self)strongSelf = weakself;
            [strongSelf enterItemList];
        }];
    }
    return _imgScrollView;
}

-(AuctionHallCountDownView *)countDownView
{
    if (!_countDownView) {
        _countDownView = [[AuctionHallCountDownView alloc]init];
        _countDownView.layer.opacity = 0;
        [self.view addSubview:_countDownView];
    }
    return _countDownView;
}

-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc]init];
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundColor = [UIColor clearColor];
        _table.separatorColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
        [self.view addSubview:_table];
    }
    return _table;
}

-(AuctionHallItemIntroTimer *)itemIntroTimer
{
    if (!_itemIntroTimer) {
        _itemIntroTimer = [[AuctionHallItemIntroTimer alloc]init];
        
        WS(weakSelf);
        [_itemIntroTimer setInsertModelBlock:^(NSString *text){
            AuctionHallItemIntrolModel *introModel = [[AuctionHallItemIntrolModel alloc]init];
            introModel.text = text;
            
            AuctionHallItemIntroViewModel *viewModel = [[AuctionHallItemIntroViewModel alloc]init];
            viewModel.dataModel = introModel;
            [weakSelf.viewModels addViewModel:viewModel];
            [weakSelf.table reloadData];
        }];
    }
    return _itemIntroTimer;
}

@end
