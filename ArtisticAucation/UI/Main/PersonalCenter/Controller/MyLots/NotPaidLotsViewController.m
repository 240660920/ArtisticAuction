//
//  NotPayingLotsViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/16.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "NotPaidLotsViewController.h"
#import "NSString+PriceString.h"
#import "PayViewController.h"
#import "SettlementModule.h"
#import "AucationItemDetailViewController.h"

@interface NotPaidLotsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UIView *footedView;
@property(nonatomic,retain)UILabel *amountLabel;
@property(nonatomic,retain)UIButton *settleButton;

@end

@implementation NotPaidLotsViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:PaymentFinishedNotification object:nil];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paymentFinished:) name:PaymentFinishedNotification object:nil];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.footedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@49);
    }];
    
    [self.table mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.footedView.mas_top).offset(-10);
    }];
}

-(void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"userid"] = [UserInfo sharedInstance].userId;
    params[@"type"] = @"1003";
    params[@"payment"] = @"0";
    
    [HttpManager requestWithAPI:@"company/queryMyCollect" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
        
        MyCollectedLotsListResponse *response = [[MyCollectedLotsListResponse alloc]initWithString:request.responseString error:nil];
        [self.dataSource addObjectsFromArray:response.data];
        
        
        [self.dataSource sortUsingComparator:^NSComparisonResult(MyCollectedLotItem *obj1, MyCollectedLotItem *obj2) {
            return obj1.createtime.intValue > obj2.createtime.intValue ? NSOrderedAscending : NSOrderedDescending;
        }];
        
        [self.table reloadData];

        
    } failed:^(ASIFormDataRequest *request) {
        [self.view showHudAndAutoDismiss:NetworkErrorPrompt];
    }];
}

-(void)selectLot:(UIButton *)sender
{
    BOOL atLeastOneSelected = NO;
    
    sender.selected = !sender.selected;
    
    NSInteger tag = sender.tag;
    
    [(MyCollectedLotItem *)self.dataSource[tag] setSelected:sender.selected];
    
    [self.table reloadData];
    
    NSInteger goodsCount = 0;
    //计算总价
    CGFloat totalAmount = 0; //含佣金
    CGFloat goodsAmount = 0; //不含佣金
    for (MyCollectedLotItem *item in self.dataSource) {
        if (item.selected) {
            goodsAmount += item.commodity.endprice.floatValue;
            totalAmount += item.commodity.endprice.floatValue * 1.05;
            
            goodsCount++;
            
            atLeastOneSelected = YES;
        }
    }
    
    
    NSMutableAttributedString *promptAttrStr = [[NSMutableAttributedString alloc]initWithString:@"合计：" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14] , NSForegroundColorAttributeName : BlackColor}];
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",totalAmount] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16] , NSForegroundColorAttributeName : [UIColor colorWithRed:1 green:51.0/255.0 blue:51.0/255.0 alpha:1]}];
    [promptAttrStr appendAttributedString:attrString];
    
    
    self.amountLabel.attributedText = promptAttrStr;
    
    if (atLeastOneSelected) {
        self.settleButton.enabled = YES;
        self.settleButton.backgroundColor = RedColor;
    }
    else{
        self.settleButton.enabled = NO;
        self.settleButton.backgroundColor = RedColorWithAlpha;
    }
}

-(void)settle
{
    NSInteger goodsCount = 0;
    //计算总价
    CGFloat totalAmount = 0; //含佣金
    CGFloat goodsAmount = 0; //不含佣金
    
    SettlementModule *module = [[SettlementModule alloc]init];
    module.goodsIdsArray = [[NSMutableArray alloc]init];
    module.itemsArray = [[NSMutableArray alloc]init];
    
    for (MyCollectedLotItem *item in self.dataSource) {
        if (item.selected) {
            goodsAmount += item.commodity.endprice.floatValue;
            totalAmount += item.commodity.endprice.floatValue * 1.05;
            
            goodsCount++;
            
            [module.goodsIdsArray addObject:item.caseid];
            [module.itemsArray addObject:item];
        }
    }
    
    module.goodsCount = goodsCount;
    module.goodsAmount = [NSString stringWithFormat:@"%.2f",goodsAmount];
    module.totalAmount = [NSString stringWithFormat:@"%.2f",totalAmount];
    
    PayViewController *vc = [[PayViewController alloc]init];
    vc.settlementModule = module;
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

-(void)paymentFinished:(NSNotification *)notice
{
    NSArray *items = notice.object;
    
    [items enumerateObjectsUsingBlock:^(MyCollectedLotItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sid != %@",obj.sid];
        [self.dataSource filterUsingPredicate:predicate];
    }];
    
    [self.table reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIButton *)settleButton
{
    if (!_settleButton) {
        _settleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _settleButton.enabled = NO;
        [_settleButton setBackgroundColor:RedColorWithAlpha];
        [_settleButton setTitle:@"结算" forState:UIControlStateNormal];
        _settleButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_settleButton addTarget:self action:@selector(settle) forControlEvents:UIControlEventTouchUpInside];
        
        [self.footedView addSubview:_settleButton];
        
        [_settleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.footedView);
            make.width.equalTo(_footedView).multipliedBy(190.0/640.0);
        }];
    }
    return _settleButton;
}


-(UIView *)footedView
{
    if (!_footedView) {
        _footedView = [[UIView alloc]init];
        _footedView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        
        [_footedView addSubview:self.settleButton];
    
        /**
         label
         */
        self.amountLabel = [[UILabel alloc]init];
        self.amountLabel.attributedText = [NSString redPriceOfValue:@"0" WithPromptString:@"合计："];
        [_footedView addSubview:self.amountLabel];
        
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footedView).offset(20);
            make.centerY.equalTo(_footedView);
        }];
        
        [self.view addSubview:_footedView];
    }
    return _footedView;
}

@end
