//
//  AuctionHallViewController.m
//  ArtisticAuction
//
//  Created by xieran on 2017/4/25.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallViewController.h"
#import "AuctionHallViewController+MessageManager.h"

@interface AuctionHallViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MQTTSessionDelegate,AVAudioPlayerDelegate>

@property(nonatomic,strong)UIView *headerView;

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
    
    
    AuctionHallItemIntrolModel *introlModel = [[AuctionHallItemIntrolModel alloc]init];
    introlModel.text = @"本件拍品：lot1";
    AuctionHallItemIntroViewModel *introlViewModel = [[AuctionHallItemIntroViewModel alloc]init];
    introlViewModel.dataModel = introlModel;
    
    
    
    AuctionHallChatModel *chatModel = [[AuctionHallChatModel alloc]init];
    chatModel.time = @"2010-01-10 10:00:00";
    chatModel.chatContent = @"梵蒂冈还点饭接口刮打工皇帝发广告打飞机怪怪的风格发广告";
    chatModel.userName = @"13515110650";
    AuctionHallChatViewModel *chatViewModel = [[AuctionHallChatViewModel alloc]init];
    chatViewModel.dataModel = chatModel;
    
    AuctionHallChatModel *chatModel2 = [[AuctionHallChatModel alloc]init];
    chatModel2.time = @"2010-01-10 10:00:00";
    chatModel2.chatContent = @"开个房测试很反感打工皇帝发广";
    chatModel2.userName = @"18652043055";
    AuctionHallChatViewModel *chatViewModel2 = [[AuctionHallChatViewModel alloc]init];
    chatViewModel2.dataModel = chatModel2;
    
    
    AuctionHallBidModel *bidModel = [[AuctionHallBidModel alloc]init];
    bidModel.phone = @"17302150722";
    bidModel.price = @"100";
    bidModel.time = @"2010-01-01 10:20:20";
    AuctionHallBidViewModel *bidViewModel = [[AuctionHallBidViewModel alloc]init];
    bidViewModel.dataModel = bidModel;
    
    AuctionHallBidModel *bidModel2 = [[AuctionHallBidModel alloc]init];
    bidModel2.phone = @"18652043055";
    bidModel2.price = @"100000";
    bidModel2.time = @"2011-11-11 10:20:20";
    AuctionHallBidViewModel *bidViewModel2 = [[AuctionHallBidViewModel alloc]init];
    bidViewModel2.dataModel = bidModel2;
    
    [self.viewModels addObject:introlViewModel];
    [self.viewModels addObject:chatViewModel];
    [self.viewModels addObject:chatViewModel2];
    [self.viewModels addObject:bidViewModel];
    [self.viewModels addObject:bidViewModel2];
    [self.table reloadData];
}

-(void)willMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"%@",parent);
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
    
    
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.frame = CGRectMake(0, 0, Screen_Width, Screen_Width - 100 + 55);
        self.table.tableHeaderView = _headerView;
    }
    
    self.imgScrollView.frame = CGRectMake(0, 0, Screen_Width, Screen_Width - 100);
    self.stateView.frame = CGRectMake(0, Screen_Width - 100, Screen_Width, 55);

    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@44);
    }];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
        make.bottom.equalTo(self.bottomView.mas_top);
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        if (rsp != nil && rsp.result.resultCode.intValue == 0) {
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
            [self.mqttSession subscribeToTopic:self.oid atLevel:MQTTQosLevelAtLeastOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
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
    
    [self handleMessageString:str];
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





-(void)enterItemDetail
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
        [self.headerView addSubview:_stateView];
        
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
        [self.headerView addSubview:_imgScrollView];

        __weak __typeof(self)weakself = self;
        [_imgScrollView setTapBlock:^(NSArray *imgUrls, NSInteger currentIndex, id dataModel) {
            __strong __typeof(self)strongSelf = weakself;
            [strongSelf enterItemDetail];
        }];
    }
    return _imgScrollView;
}

-(AuctionHallCountDownView *)countDownView
{
    if (!_countDownView) {
        _countDownView = [[AuctionHallCountDownView alloc]init];
        _countDownView.layer.opacity = 0;
        [self.imgScrollView addSubview:_countDownView];
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
//        _table.separatorColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
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

-(AVAudioPlayer *)countDownSoundPlayer{
    if (!_countDownSoundPlayer) {
        _countDownSoundPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:[[NSBundle mainBundle]pathForResource:@"count_down_sound" ofType:@"mp3"]] error:nil];
        _countDownSoundPlayer.numberOfLoops = 5;
    }
    return _countDownSoundPlayer;
}

-(AVAudioPlayer *)dealSoundPlayer{
    if (!_dealSoundPlayer) {
        _dealSoundPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:[[NSBundle mainBundle]pathForResource:@"deal_sound" ofType:@"m4a"]] error:nil];
        _dealSoundPlayer.volume = 0.8;
    }
    return _dealSoundPlayer;
}

@end
