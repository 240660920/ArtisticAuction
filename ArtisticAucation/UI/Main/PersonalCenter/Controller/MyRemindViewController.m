//
//  MyRemindViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/16.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "MyRemindViewController.h"
#import "RemindCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyRemindResponse.h"
#import "Remind.h"

@interface MyRemindViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}

@end

@implementation MyRemindViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的提醒";
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation"]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self requestForMyRemind];
}

-(void)requestForMyRemind
{
    [_dataArray removeAllObjects];
    [HttpManager requestWithAPI:@"company/queryMyRemind" params:@{@"userid" : [UserInfo sharedInstance].userId} requestMethod:@"GET" completion:^(ASIFormDataRequest *request) {
        
        MyRemindResponse *response = [[MyRemindResponse alloc]initWithString:request.responseString error:nil];
        if (response && response.result.resultCode.intValue == 0) {
            [_dataArray addObjectsFromArray:response.data];
            [_tableView reloadData];
        }
        else{
            [self.view showHudAndAutoDismiss:@"请求失败"];
        }
        
    } failed:^(ASIFormDataRequest *request) {
        [self.view showHudAndAutoDismiss:@"网络异常，请检查网络后重试"];
    }];
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    RemindCell *cell = (RemindCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"RemindCell" owner:self options:nil][0];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    RemindDataModel *model = _dataArray[indexPath.section];

    cell.titleLabel.text = model.occasion.odescription;
    [cell.headIV sd_setImageWithURL:[NSURL URLWithString:[model.occasion.imgurl completeImageUrlString]] placeholderImage:nil];
    cell.startTimeLabel.text = [NSString stringWithFormat:@"%@开始",model.occasion.starttime];
    
    cell.people.text = model.occasion.enterTotals;
    cell.favite.text = model.occasion.collectTotals;
    
    [cell setMyRemindBlock:^(void){
        [self requestForDeleteRemindWithOid:model.occasion.oid];
    }];
    return cell;
}

-(void)requestForDeleteRemindWithOid:(NSString *)oid
{
    [Remind deleteRemindWithOid:oid successBlock:^{
        
        [self requestForMyRemind];
        
    } failedBlock:^{
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 197;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 20;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}


-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
