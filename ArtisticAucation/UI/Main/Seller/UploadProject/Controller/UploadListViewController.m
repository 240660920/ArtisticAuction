//
//  UploadProViewController.m
//  ArtisticAucation
//
//  Created by Haley on 15/11/2.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "UploadListViewController.h"
#import "UploadListCell.h"
#import "UploadItemViewController.h"
#import "UploadItemManager.h"
#import "ZYQAssetPickerController.h"
#import "EditImageViewController.h"

@interface UploadListViewController ()<UITableViewDataSource,UITableViewDelegate,ASIProgressDelegate,ZYQAssetPickerControllerDelegate>
{
    int imagesDataLength;
    int sendedDataLength;
    
    MBProgressHUD *progressHud;
}

@property(nonatomic,strong)NSMutableArray *dataSourceArray;

@end

@implementation UploadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [Utils rightItemWithTitle:@"上传" target:self selector:@selector(upload)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    _dataSourceArray = [[NSMutableArray alloc]init];
    [_dataSourceArray addObjectsFromArray:[UploadItemManager localItems]];
    
    //专场图片
    if ([[UploadItemManager sharedInstance]occasionImage]) {
        [self reloadOccasionImageView:[[UploadItemManager sharedInstance]occasionImage]];
    }
    
    self.addImageButton.layer.masksToBounds = YES;
    self.addImageButton.layer.borderColor = TableViewSeparateColor.CGColor;
    self.addImageButton.layer.borderWidth = 0.5;
    
    [self.occasionImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addImage:)]];
    
    [self configTable];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@第%@场",[UserInfo sharedInstance].agencyName,[Utils translateArabNumberToChinese:[NSString stringWithFormat:@"%u",[UserInfo sharedInstance].occasionList.count + 1]]];
}

-(void)upload
{
    if (self.dataSourceArray.count < UploadMinCount) {
        [self.view showHudAndAutoDismiss:[NSString stringWithFormat:@"拍品数量不得少于%d件",UploadMinCount]];
        return;
    }
    else if (self.dataSourceArray.count > UploadMaxCount){
        [self.view showHudAndAutoDismiss:[NSString stringWithFormat:@"拍品数量不得多于%d件",UploadMaxCount]];
        return;
    }
    else if (!self.occasionImageView.image){
        [self.view showHudAndAutoDismiss:@"请选择专场图片"];
        return;
    }
    else if ([self itemNameDuplicated]){
        [self.view showHudAndAutoDismiss:@"拍品名称不能重复"];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"拍场及拍品信息一经提交将无法修改" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认提交", nil];
    [alert show];
    [alert handleClickedButton:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self postData];
        }
    }];
}

-(void)postData
{
    sendedDataLength = 0;
    
    progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHud.labelText = @"0%";
    
    
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"userid"] = [UserInfo sharedInstance].userId;
//    params[@"oname"] = [UserInfo sharedInstance].agencyName;
//    if ([UserInfo sharedInstance].aid) {
//        params[@"aid"] = [UserInfo sharedInstance].aid;
//    }
    

    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",ServerUrl,@"company/addVerOccasion"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setUploadProgressDelegate:self];
    request.showAccurateProgress = YES;
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    __weak ASIFormDataRequest *weakRequest = request;
    for (NSString *key in [params allKeys]) {
        [request addPostValue:[params objectForKey:key] forKey:key];
    }
    

    
    //专场图片
    [request addPostValue:@"occasionName" forKey:@"fileName"];
    [request addData:UIImageJPEGRepresentation(self.occasionImageView.image,0.1) forKey:@"fileData"];
    
    //拍品
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        UploadItem *item = self.dataSourceArray[i];

        [request addPostValue:item.property forKey:@"type"];
        [request addPostValue:item.name forKey:@"cname"];
        [request addPostValue:item.price forKey:@"startprice"];
        [request addPostValue:item.features forKey:@"feature"];
        [request addPostValue:@(item.images.count) forKey:@"imgcount"];
        [request addPostValue:item.desc forKey:@"description"];
        
        [item.images enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *fileName = [NSString stringWithFormat:@"aucationItem%d%lu.jpg",i,(unsigned long)idx];
            [request addPostValue:fileName forKey:@"fileName"];
            
            NSData *imageData = UIImageJPEGRepresentation(obj,0.2);
            [request addData:imageData withFileName:fileName andContentType:@"image/jpg" forKey:@"fileData"];
        }];
    }
    
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:30];
    [request setCompletionBlock:^{
        AABaseJSONModelResponse *response = [[AABaseJSONModelResponse alloc]initWithString:weakRequest.responseString error:nil];
        if (response && response.result.resultCode.intValue == 0) {
            progressHud.label.text = @"100%";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [progressHud hideAnimated:NO];
                
                [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:@"审核将在两个工作日内完成"];
            });
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadMyOccasionsList" object:nil];
            
            //清除拍品缓存
            [UploadItemManager removeAllItems];
            //清除专场图片缓存
            [[UploadItemManager sharedInstance]deleteOccasionImage];
            
            [self.dataSourceArray removeAllObjects];
            [self.table reloadData];
            self.occasionImageView.image = nil;
            self.addImageButton.hidden = NO;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                UIViewController *controller = [self.navigationController.viewControllers objectAtIndex:1];
                [self.navigationController popToViewController:controller animated:YES];
            });
        }
        else{
            [progressHud hideAnimated:NO];
            [self.view showHudAndAutoDismiss:@"开设新专场失败"];
        }
    }];
    [request setFailedBlock:^{
        [progressHud hideAnimated:NO];
        [self.view showHudAndAutoDismiss:NetworkErrorPrompt];
    }];
    
    [request startAsynchronous];
}

-(void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength
{
    if (newLength > 0) {
        imagesDataLength = (int)newLength;
    }
}

- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes
{
    sendedDataLength += (int)bytes;

    float progress = (float)sendedDataLength / (float)imagesDataLength;
    if (progress > 1 || progress < 0) {
        progress = 1;
    }
    progressHud.label.text = [NSString stringWithFormat:@"%.0f%%",progress * 100];
}

#pragma mark TabelView delegate
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.navigationItem.rightBarButtonItem.customButton.enabled = self.dataSourceArray.count > 0;
    [self.addButton setTitle:[NSString stringWithFormat:@"添加拍品(%lu/%d件)",(unsigned long)self.dataSourceArray.count,UploadMaxCount] forState:UIControlStateNormal];
    if (self.dataSourceArray.count == UploadMaxCount) {
        self.addButton.enabled = NO;
        self.addButton.alpha = 0.75;
    }
    return self.dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UploadCell";
    UploadListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    cell.backgroundColor = [UIColor clearColor];
    
    UploadItem *item = self.dataSourceArray[indexPath.row];
    cell.nameLabel.text = item.name;
    cell.propertyLabel.text = [[item.property componentsSeparatedByString:@"-"] lastObject];
    cell.priceLabel.attributedText = [NSString redPriceOfValue:item.price];
    cell.iconImageView.image = item.images.count > 0 ? item.images[0] : nil;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UploadItem *item = self.dataSourceArray[indexPath.row];
    UploadItemViewController *vc = [[UploadItemViewController alloc]init];
    vc.item = item;
    vc.didSelectItemBlock = ^(UploadItem *item){
        [self.dataSourceArray replaceObjectAtIndex:indexPath.row withObject:item];
        [self.table reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication].keyWindow showLoadingHudWithText:@"请稍候..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UploadItemManager removeItem:self.dataSourceArray[indexPath.row]];
        
        [self.dataSourceArray removeObjectAtIndex:indexPath.row];
        [self.table reloadData];
        
        [[UIApplication sharedApplication].keyWindow hideAllHud];
    });
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
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

#pragma mark ImagePicker delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker dismissViewControllerAnimated:NO completion:^{
        EditImageViewController *vc = [[EditImageViewController alloc]init];
        ALAssetRepresentation *al = [assets[0] defaultRepresentation];
        vc.image = [[UIImage imageWithCGImage:[al fullResolutionImage]]fixOrientationOfOrientation:al.orientation];
        [vc setEditImageBlock:^(UIImage *editedImage) {
            [self reloadOccasionImageView:editedImage];
        }];
        [self.navigationController pushViewController:vc animated:NO];
    }];
}

-(void)reloadOccasionImageView:(UIImage *)image
{
    self.occasionImageView.image = image;
    
    [[UploadItemManager sharedInstance]saveOccasionImage:image];
    
    CGRect frame = self.occasionImageView.frame;
    frame.size.width = image.size.width / image.size.height * frame.size.height;
    self.occasionImageView.frame = frame;

    if (image) {
        self.addImageButton.hidden = YES;
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

- (IBAction)add:(id)sender {
    
    UploadItemViewController *vc = [[UploadItemViewController alloc]init];
    vc.index = self.dataSourceArray.count + 1;
    vc.didSelectItemBlock = ^(UploadItem *item){
        [self.dataSourceArray addObject:item];
        [self.table reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)addImage:(id)sender {
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
    picker.maximumNumberOfSelection = 1;
    picker.showEmptyGroups = YES;
    picker.delegate = (id)self;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

-(void)configTable
{
    [self.table registerNib:[UINib nibWithNibName:@"UploadListCell" bundle:nil] forCellReuseIdentifier:@"UploadCell"];
    self.table.tableHeaderView = self.tableHeaderView;
    
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.table setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.table respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.table setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    [self.table reloadData];
}

-(BOOL)itemNameDuplicated
{
    __block BOOL duplicated = NO;
    
    [self.dataSourceArray enumerateObjectsUsingBlock:^(UploadItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataSourceArray enumerateObjectsUsingBlock:^(UploadItem *obj_, NSUInteger idx_, BOOL * _Nonnull stop_) {
            if ((obj != obj_) && ([obj.name isEqualToString:obj_.name])) {
                duplicated = YES;
            }
        }];
    }];
    
    return duplicated;
}

@end
