//
//  PaidLotsViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/16.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "PaidLotsViewController.h"
#import "MyLotsCell.h"

@interface PaidLotsViewController ()

@end

@implementation PaidLotsViewController

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

-(void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"userid"] = [UserInfo sharedInstance].userId;
    params[@"type"] = @"1003";
    params[@"payment"] = @"1";
    
    [HttpManager requestWithAPI:@"company/queryMyCollect" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
        
        MyCollectedLotsListResponse *response = [[MyCollectedLotsListResponse alloc]initWithString:request.responseString error:nil];
        [self.dataSource addObjectsFromArray:response.data];
        
        [self.table reloadData];
        
        
    } failed:^(ASIFormDataRequest *request) {
        [self.view showHudAndAutoDismiss:NetworkErrorPrompt];
    }];
}

-(void)paymentFinished:(NSNotification *)notice
{
    NSArray *items = notice.object;
    for (MyCollectedLotItem *item in items) {
        item.payment = @"1";
        [self.dataSource insertObject:item atIndex:0];
    }
    
    [self.table reloadData];
}

@end
