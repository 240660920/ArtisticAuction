//
//  OpenupSessionViewController.m
//  ArtisticAucation
//
//  Created by Haley on 15/11/2.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "OpenupSessionViewController.h"
#import "OpenUpCell.h"
#import "UploadListViewController.h"
#import "AucationItemsListViewController.h"
#import <objc/runtime.h>

@interface OpenupSessionViewController ()

@end

@implementation OpenupSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"往期拍场";

    self.tableView.backgroundView = [UIView backgroundView];
    
    [self requestData];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:@"ReloadMyOccasionsList" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self requestData];
    }];
}

-(void)pop
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)requestData
{
    [self.view showLoadingHud];

    [HttpManager requestWithAPI:@"user/userOccasion" params:@{@"userid" : [UserInfo sharedInstance].userId} requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
        
        [self.view hideAllHud];
        
        AucationListResponse *response = [[AucationListResponse alloc]initWithString:request.responseString error:nil];
        if (response && response.result.resultCode.intValue == 0) {
            [[UserInfo sharedInstance].occasionList removeAllObjects];
            [[UserInfo sharedInstance].occasionList addObjectsFromArray:response.data];
            
            if (response.data.count > 0) {
                AucationDataModel *aucation = response.data[0];
                [UserInfo sharedInstance].aid = aucation.aid;
            }
            
            [self.tableView reloadData];
        }
        
    } failed:^(ASIFormDataRequest *request) {
        [self.view showHudAndAutoDismiss:NetworkErrorPrompt];
    }];
}

-(IBAction)actionAddNew:(id)sender
{
    UploadListViewController *vc = objc_getAssociatedObject([UIApplication sharedApplication].delegate, "UploadListViewController");
    if (!vc) {
        vc = [[UploadListViewController alloc]init];
        
        objc_setAssociatedObject([UIApplication sharedApplication].delegate, "UploadListViewController", vc, OBJC_ASSOCIATION_RETAIN);
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [UserInfo sharedInstance].occasionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    OpenUpCell *cell = (OpenUpCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"OpenUpCell" owner:self options:nil][0];
    }
    
    AucationDataModel *aucationModel = [UserInfo sharedInstance].occasionList[indexPath.row];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.nameLabel.text = aucationModel.occasionName;
    
    if (aucationModel.verifystatus.intValue == 0) { //正在审核
        cell.nameLabel.textColor = [UIColor colorWithRed:0xb2/255.0 green:0xb4/255.0 blue:0xbd/255.0 alpha:1];
    }
    else{  //通过审核
        cell.nameLabel.textColor = BlackColor;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AucationDataModel *aucationModel = [UserInfo sharedInstance].occasionList[indexPath.row];
    if (aucationModel.verifystatus.integerValue == 1) {
        AucationItemsListViewController *vc = [[AucationItemsListViewController alloc]init];
        vc.oid = [[UserInfo sharedInstance].occasionList[indexPath.row] oid];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该专场正在审核中" message:@"审核将在两个工作日内结束" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
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
