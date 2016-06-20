//
//  PayViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/19.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "PayViewController.h"
#import "PayTableViewCell.h"
#import "SettlementModule.h"
#import "AlipayManager.h"
#import "WeixinPayManager.h"
#import "WXApi.h"
#import "AddressInfo.h"
#import "MyInfoViewController.h"
#import "ContactInfoTableViewCell.h"

@interface PayViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView *table;
@property(nonatomic,retain)UIButton *payButton;
@property(nonatomic,retain)AddressInfo *addressInfo;

@end

@implementation PayViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:WeixinPaySuccessNotice object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"结算";
    
    [self.table reloadData];
    
    
    self.settlementModule.settlementType = kSettlementTypeWeixin;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveWeixinPaySuccessNotice) name:WeixinPaySuccessNotice object:nil];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    UITableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
    CGRect cellFrame = [self.view convertRect:cell.frame fromView:self.table];
    
    self.table.frame = CGRectMake(0, 0, Screen_Width, CGRectGetMaxY(cell.frame) + 20 + 44);
    
    self.payButton.frame = CGRectMake(10, CGRectGetMaxY(cellFrame) + 20, Screen_Width - 20, 44);
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else if(section == 1){
        return 3;
    }
    else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && self.addressInfo) {
        return 80;
    }
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PayTableViewCell";
    PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.cellType = PayTableViewCellTypeCheckbox;
        if (indexPath.row == 0) {
            cell.leftTitle = @"微信支付";
            [cell.checkBox setSelected:self.settlementModule.settlementType == kSettlementTypeWeixin];
        }
        else if(indexPath.row == 1){
            cell.leftTitle = @"支付宝支付";
            [cell.checkBox setSelected:self.settlementModule.settlementType == kSettlementTypeAlipay];
        }
        else{
            cell.leftTitle = @"银行卡支付";
            [cell.checkBox setSelected:self.settlementModule.settlementType == kSettlementTypeBankCard];
        }
    }
    else if(indexPath.section == 1){
        cell.accessoryType = UITableViewCellAccessoryNone;
        switch (indexPath.row) {
            case 0:
                cell.cellType = PayTableViewCellTypeWithBlackLabel;
                cell.leftTitle = @"商品共计";
                cell.rightTitle = [NSString stringWithFormat:@"%ld件",(long)self.settlementModule.goodsCount];
                break;
            case 1:
                cell.cellType = PayTableViewCellTypeWithBlackLabel;
                cell.leftTitle = @"商品总价";
                cell.rightTitle = [NSString stringWithFormat:@"￥%@",self.settlementModule.goodsAmount];
                break;
            case 2:
                cell.cellType = PayTableViewCellTypeWithRedLabel;
                cell.leftTitle = @"实际需要支付";
                cell.rightTitle = [NSString stringWithFormat:@"￥%@",self.settlementModule.totalAmount];
                break;
            default:
                break;
        }
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (!self.addressInfo) {
            cell.leftTitle = @"选择收货地址";
        }
        else{
            ContactInfoTableViewCell *cell = [[ContactInfoTableViewCell alloc]init];
            cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
            cell.nameLabel.text = self.addressInfo.name;
            cell.phoneNumLabel.text = self.addressInfo.phoneNum;
            cell.addressLabel.text = self.addressInfo.address;
            
            return cell;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.settlementModule.settlementType = kSettlementTypeWeixin;
            
            self.payButton.enabled = YES;
        }
        else if (indexPath.row == 1){
            self.settlementModule.settlementType = kSettlementTypeAlipay;
            
            self.payButton.enabled = YES;
        }
        else if (indexPath.row == 2){
            self.settlementModule.settlementType = kSettlementTypeBankCard;
            
            self.payButton.enabled = NO;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"渤海银行\n2001873516000186" message:@"已为您复制到剪贴板" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            [UIPasteboard generalPasteboard].string = @"2001873516000186";
        }
        [self.table reloadData];
    }
    else if (indexPath.section == 2){
        MyInfoViewController *vc = [[MyInfoViewController alloc]init];
        vc.didSelectPersonalInfoBlock = ^(AddressInfo *addressInfo){
            self.addressInfo = addressInfo;
            [self.table reloadData];
            
            [self viewWillLayoutSubviews];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma pay
-(void)pay
{
    if (!self.addressInfo) {
        [[[UIAlertView alloc]initWithTitle:@"请选择收货地址" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    if (self.settlementModule.settlementType == kSettlementTypeAlipay) {
        AlipayOrder *order = [[AlipayOrder alloc] init];
        order.appID = @"2015100800398750";
        order.partner = @"2088021821374404";
        order.seller = @"3283467416@qq.com";
        order.tradeNO = [NSString ret12bitStringAppendTimeIntervalSince1970]; //订单ID(由商家□自□行制定)
        order.productName = @"拍品结算"; //商品标题
        order.productDescription = @"商品结算"; //商品描述
        order.amount = self.settlementModule.totalAmount; //商 品价格
        order.notifyURL = [NSString stringWithFormat:@"%@%@",ServerUrl,@"user/zfbPayReult"]; //回调URL
        order.service = @"mobile.securitypay.pay";
        order.paymentType = @"1";
        order.inputCharset = @"utf-8";
        order.itBPay = @"30m";
        order.caseId = [self.settlementModule.goodsIdsArray stringSeparateBySymbol:@","];
        order.username = self.addressInfo.name;
        order.phoneNum = self.addressInfo.phoneNum;
        order.address = self.addressInfo.address;
        
        
        [[AlipayManager sharedInstance]payOrder:order completionBlock:^(NSDictionary *resultDic) {
            //付款成功
            [self.view showHudAndAutoDismiss:@"支付成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:PaymentFinishedNotification object:self.settlementModule.itemsArray];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } controller:self];
    }
    else if (self.settlementModule.settlementType == kSettlementTypeWeixin){
        if (![WXApi isWXAppInstalled]) {
            [self.view showHudAndAutoDismiss:@"请先安装微信"];
            return;
        }
        
        WeixinPayModule *module = [[WeixinPayModule alloc]init];
        module.body = @"拍品结算";
        module.caseId = [self.settlementModule.goodsIdsArray stringSeparateBySymbol:@","];
        module.totalFee = self.settlementModule.totalAmount;
        module.username = self.addressInfo.name;
        module.phoneNum = self.addressInfo.phoneNum;
        module.address  = self.addressInfo.address;
 
        //回调结果在appdelegate中监听，以通知形式返回
        [WeixinPayManager payWithModule:module controller:self];
    }
    else if (self.settlementModule.settlementType == kSettlementTypeBankCard){
        
    }

}

-(void)didReceiveWeixinPaySuccessNotice
{
    [self.view showHudAndAutoDismiss:@"支付成功"];
    [[NSNotificationCenter defaultCenter]postNotificationName:PaymentFinishedNotification object:self.settlementModule.itemsArray];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark Properties
-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _table.dataSource = self;
        _table.delegate = self;
        _table.backgroundView = [UIView backgroundView];
        _table.separatorColor = TableViewSeparateColor;
        _table.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        [self.view addSubview:_table];
    }
    return _table;
}

-(UIButton *)payButton
{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setBackgroundImage:[[UIImage imageNamed:@"red_button_nor"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage imageNamed:@"red_button_sel"] forState:UIControlStateHighlighted];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payButton setTitle:@"确认支付" forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
        [self.table addSubview:_payButton];
    }
    return _payButton;
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
