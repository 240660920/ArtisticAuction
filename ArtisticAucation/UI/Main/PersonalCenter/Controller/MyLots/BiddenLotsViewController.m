//
//  BiddenLotsViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/10/16.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "BiddenLotsViewController.h"
#import "MyLotsCell.h"
@interface BiddenLotsViewController ()

@end

@implementation BiddenLotsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestData];
}

-(void)requestData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"userid"] = [UserInfo sharedInstance].userId;
    params[@"type"] = @"1003";
    params[@"payment"] = @"2";
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
