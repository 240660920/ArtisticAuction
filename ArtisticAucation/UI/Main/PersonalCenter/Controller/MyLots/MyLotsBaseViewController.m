//
//  MyLotsBaseViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/16.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "MyLotsBaseViewController.h"
#import "MyCollectedLotsListResponse.h"
#import "NotPaidLotsViewController.h"
#import "PaidLotsViewController.h"
#import "BiddenLotsViewController.h"
#import "AucationItemDetailViewController.h"

@interface MyLotsBaseViewController ()

@end

@implementation MyLotsBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    _dataSource = [[NSMutableArray alloc]init];
    
    [self.table reloadData];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyLotsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyLotsCell"];
    cell.tag = indexPath.section;

    MyCollectedLotItem *lotItem = self.dataSource[indexPath.section];
    MyCollcetedLotDetailItem *item = lotItem.commodity;
    
    cell.aucationNameLabel.text = lotItem.commodity.occasion.occasionName;
    cell.titleLabel.text = item.descString;
    [cell.lotImageView sd_setImageWithURL:[NSURL URLWithString:[item.images[0] completeImageUrlString]] placeholderImage:AucationItem_PlaceHolderImage];
    cell.closingPriceLabel.text = [NSString stringWithFormat:@"成交价： %@",item.endprice];
    cell.commissionPriceLabel.text = [NSString stringWithFormat:@"佣金5%%：%.2f",item.endprice.floatValue * 0.05];
    
    NSInteger payment = [[self.dataSource[indexPath.section]payment]intValue];
    //未支付和已支付
    if (payment == 0 || payment == 1) {
        NSString *promptStr = payment == 0 ? @"需支付：" : @"已支付：";
        NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc]initWithString:promptStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12] , NSForegroundColorAttributeName : [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]}];
        [attrStr1 appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",item.endprice.floatValue * 1.05] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16] , NSForegroundColorAttributeName : [UIColor colorWithRed:1 green:51.0/255.0 blue:51.0/255.0 alpha:1]}]];
        cell.totalAmountLabel.attributedText = attrStr1;
    }
    //参拍记录
    else{
        NSString *stateStr;
        switch (item.status.intValue) {
            case DealNotStart:
                stateStr = @"未开始";
                break;
            case DealOngoing:
                stateStr = @"进行中";
                break;
            case DealFinished:
                stateStr = @"成交";
                break;
            case DealFailed:
                stateStr = @"流拍";
                break;
            default:
                break;
        }
        cell.totalAmountLabel.text = stateStr;
    }
    
    /**
     *  checkbox
     */
    if ([self class] == [NotPaidLotsViewController class]) {
        cell.checkbox.selected = [self.dataSource[indexPath.section] selected];
        cell.checkbox.hidden = NO;
        [cell.checkbox removeTarget:self action:@selector(selectLot:) forControlEvents:UIControlEventTouchUpInside];
        [cell.checkbox addTarget:self action:@selector(selectLot:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        cell.checkbox.hidden = YES;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AucationItemDetailViewController *vc = [[AucationItemDetailViewController alloc]init];
    NSString *cid = [[self.dataSource[indexPath.section] commodity] cid];
    vc.cid = cid;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

-(void)selectLot:(UIButton *)sender
{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Properties
-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.rowHeight = MyLotTableRowHeiht;
        _table.backgroundView = [UIView backgroundView];
        _table.separatorColor = TableViewSeparateColor;
        [_table registerNib:[UINib nibWithNibName:@"MyLotsCell" bundle:nil] forCellReuseIdentifier:@"MyLotsCell"];
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
