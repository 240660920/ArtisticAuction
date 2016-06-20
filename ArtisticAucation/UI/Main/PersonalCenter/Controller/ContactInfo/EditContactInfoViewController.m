//
//  EditContactInfoViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/28.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "EditContactInfoViewController.h"
#import "AATextView.h"
#import "AddressInfo.h"

@interface EditContactInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,retain)UITableView *table;
@property(nonatomic,retain)UITextField *nameTf;
@property(nonatomic,retain)UITextField *phoneNumTf;
@property(nonatomic,retain)AATextView  *addressTv;

@end

@implementation EditContactInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"地址信息";
    
    self.navigationItem.rightBarButtonItem = [Utils rightItemWithTitle:@"保存" target:self selector:@selector(save)];
    
    if ([UserInfo sharedInstance].contactInfos.count > self.editTag) {
        AddressInfo *info = [UserInfo sharedInstance].contactInfos[self.editTag];
        self.nameTf.text = info.name;
        self.phoneNumTf.text = info.phoneNum;
        self.addressTv.text = info.address;
    }
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 44;
    }
    return 44 * 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"EditInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        [self.nameTf removeFromSuperview];
        
        self.nameTf.frame = CGRectMake(15, 0, Screen_Width - 30, 44);
        [cell.contentView addSubview:self.nameTf];
    }
    else if (indexPath.row == 1){
        [self.phoneNumTf removeFromSuperview];
        
        self.phoneNumTf.frame = CGRectMake(15, 0, Screen_Width - 30, 44);
        [cell.contentView addSubview:self.phoneNumTf];
    }
    else{
        [self.addressTv removeFromSuperview];
        
        self.addressTv.frame = CGRectMake(11, 5, Screen_Width - 22, 44 * 2 - 10);
        [cell.contentView addSubview:self.addressTv];
    }
    
    return cell;
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)save
{
    [self.view endEditing:YES];
    
    if (self.nameTf.text.length == 0) {
        [self.view showHudAndAutoDismiss:@"姓名不能为空"];
        return;
    }
    if (self.phoneNumTf.text.length == 0) {
        [self.view showHudAndAutoDismiss:@"手机号码不能为空"];
        return;
    }
    if (self.addressTv.text.length == 0) {
        [self.view showHudAndAutoDismiss:@"地址不能为空"];
        return;
    }
    
    if ([self.nameTf.text rangeOfString:@";"].length > 0 || [self.phoneNumTf.text rangeOfString:@";"].length > 0 || [self.addressTv.text rangeOfString:@";"].length > 0) {
        [self.view showHudAndAutoDismiss:@"不允许含有非法字符"];
        return;
    }
    
    NSString *regex = @"^[1][3578][0-9]{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![predicate evaluateWithObject:[self.phoneNumTf.text stringByReplacingOccurrencesOfString:@"-" withString:@""]]) {
        [self.view showHudAndAutoDismiss:@"请输入正确的手机号码"];
        return;
    }
    
    [self.view showLoadingHud];
    
    AddressInfo *newInfo = [[AddressInfo alloc]init];
    newInfo.name = self.nameTf.text;
    newInfo.phoneNum = self.phoneNumTf.text;
    newInfo.address = self.addressTv.text;
    
    NSMutableArray *names = [[NSMutableArray alloc]init];
    NSMutableArray *phones = [[NSMutableArray alloc]init];
    NSMutableArray *addresses = [[NSMutableArray alloc]init];
    for (int i = 0; i < [UserInfo sharedInstance].contactInfos.count; i++) {
        AddressInfo *info = [UserInfo sharedInstance].contactInfos[i];
        [names addObject:info.name];
        [phones addObject:info.phoneNum];
        [addresses addObject:info.address];
    }
    if ([UserInfo sharedInstance].contactInfos.count > self.editTag) {
        [names replaceObjectAtIndex:self.editTag withObject:self.nameTf.text];
        [phones replaceObjectAtIndex:self.editTag withObject:self.phoneNumTf.text];
        [addresses replaceObjectAtIndex:self.editTag withObject:self.addressTv.text];
    }
    else{
        [names addObject:self.nameTf.text];
        [phones addObject:self.phoneNumTf.text];
        [addresses addObject:self.addressTv.text];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[UserInfo sharedInstance].userId forKey:@"userid"];
    [params setObject:[names stringSeparateBySymbol:@";"] forKey:@"fullname"];
    [params setObject:[phones stringSeparateBySymbol:@";"] forKey:@"phoneNum"];
    [params setObject:[addresses stringSeparateBySymbol:@";"] forKey:@"address"];
    
    [HttpManager requestWithAPI:@"user/modifyUser" params:params requestMethod:@"POST" completion:^(ASIFormDataRequest *request) {
        [self.view hideAllHud];
        
        if ([UserInfo sharedInstance].contactInfos.count > self.editTag) {
            [[UserInfo sharedInstance].contactInfos replaceObjectAtIndex:self.editTag withObject:newInfo];
        }
        else{
            [[UserInfo sharedInstance].contactInfos addObject:newInfo];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadPersonalInfoTable" object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failed:^(ASIFormDataRequest *request) {
        [self.view showHudAndAutoDismiss:NetworkRequestErrorDomain];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundView = [UIView backgroundView];
        _table.separatorColor = TableViewSeparateColor;
        
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

-(UITextField *)nameTf
{
    if (!_nameTf) {
        _nameTf = [[UITextField alloc]init];
        _nameTf.delegate = self;
        _nameTf.font = [UIFont systemFontOfSize:16];
        _nameTf.textColor = BlackColor;
        _nameTf.placeholder = @"姓名";
        [_nameTf setValue:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        _nameTf.returnKeyType = UIReturnKeyDone;
    }
    return _nameTf;
}

-(UITextField *)phoneNumTf
{
    if (!_phoneNumTf) {
        _phoneNumTf = [[UITextField alloc]init];
        _phoneNumTf.font = [UIFont systemFontOfSize:16];
        _phoneNumTf.textColor = BlackColor;
        _phoneNumTf.placeholder = @"手机号码";
        [_phoneNumTf setValue:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        _phoneNumTf.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumTf.returnKeyType = UIReturnKeyDone;
    }
    return _phoneNumTf;
}

-(AATextView *)addressTv
{
    if (!_addressTv) {
        _addressTv = [[AATextView alloc]init];
        _addressTv.font = [UIFont systemFontOfSize:16];
        _addressTv.placeholder = @"收货地址";
        _addressTv.textColor = BlackColor;
        _addressTv.backgroundColor = [UIColor clearColor];
    }
    return _addressTv;
}

@end
