//
//  UploadItemViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/6.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "UploadItemViewController.h"
#import "PropertyListViewController.h"
#import <objc/runtime.h>
#import "AATextView.h"
#import "EditImageViewController.h"
#import "UploadItemImageView.h"
#import "ZYQAssetPickerController.h"
#import "UploadItemManager.h"

#define FeaturesPlaceholders @[@"材质",@"尺寸",@"作者及简介(可复制粘贴)"]

@interface UploadItemViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,ASIProgressDelegate,ZYQAssetPickerControllerDelegate,UploadItemImageViewDelegate>
{
    UITextField *firstResponderTf;
    
    int totalBytes;
    int sendedBytes;
    
    MBProgressHUD *uploadHud;
}
@property(nonatomic,strong)UITextField *nameTf;
@property(nonatomic,strong)UITextField *priceTf;
@property(nonatomic,strong)UIButton *addImageBtn;
@property(nonatomic,strong)AATextView *descTf;
@property(nonatomic,strong)NSMutableArray *images;
@property(nonatomic,strong)NSMutableArray *imageItems;
@property(nonatomic,strong)NSMutableArray *featuresTextFields;

@property(nonatomic,assign)NSInteger lastImageIndex;
@property(nonatomic,assign)NSInteger currentImageIndex;
@property(nonatomic,copy)NSString *propertyString;

@end

@implementation UploadItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"上传拍品";
    self.navigationItem.rightBarButtonItem = [Utils rightItemWithTitle:@"确定" target:self selector:@selector(confirm)];
    self.navigationItem.rightBarButtonItem.customButton.enabled = NO;
    
    
    if (self.item) {
        self.nameTf.text = self.item.name;
        self.priceTf.text = self.item.price;
        self.descTf.text = self.item.desc;
        self.propertyString = self.item.property;
        [self.images addObjectsFromArray:self.item.images];
        
        for (int i = 0; i < self.images.count; i++) {
            UploadItemImageView *itemView = [[UploadItemImageView alloc]init];
            itemView.delegate = self;
            itemView.image = self.images[i];
            [self.imageItems addObject:itemView];
        }
    }
    
    
    [self.table reloadData];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSelectProperty:) name:DidSelectSecondLevelProperty object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewTextDidChange) name:UITextViewTextDidChangeNotification object:nil];
}

-(void)confirm
{
    __block BOOL featuresLegal = YES;
    __block NSMutableString *featureStr = [[NSMutableString alloc]init];
    [self.featuresTextFields enumerateObjectsUsingBlock:^(UITextField *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.text rangeOfString:@";"].length > 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"材质、尺寸、作者及简介不允许输入分号" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            featuresLegal = NO;
            *stop = YES;
        }
        if (obj.text.length == 0) {
            [self.view showHudAndAutoDismiss:[NSString stringWithFormat:@"%@不能为空",FeaturesPlaceholders[idx]]];
            featuresLegal = NO;
        }
        
        
        [featureStr appendString:obj.text.length == 0 ? @" " : obj.text];
        [featureStr appendString:@";"];
    }];
    featureStr = (NSMutableString *)[featureStr substringToIndex:featureStr.length - 1];
    if (!featuresLegal) {
        return;
    }
    if (self.nameTf.text.length > 50) {
        [self.view showHudAndAutoDismiss:@"拍品名称不得超过50字"];
        return;
    }
    if (self.descTf.text.length > 300) {
        [self.view showHudAndAutoDismiss:@"拍品介绍不得超过300字"];
        return;
    }
    if (self.images.count > 8) {
        [self.view showHudAndAutoDismiss:@"图片数量不得超过8张"];
        return;
    }
    
    
    
    UploadItem *item = self.item ? self.item : [[UploadItem alloc]init];
    item.name = self.nameTf.text;
    item.price = self.priceTf.text;
    item.desc = self.descTf.text;
    item.property = self.propertyString;
    item.features = featureStr;
    item.images = self.images;
    if (!self.item) {
        item.timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date]timeIntervalSince1970]];
    }
    
    
    //如果是从批量上传进来的
    if (self.didSelectItemBlock) {
        self.didSelectItemBlock(item);
        
        [[UploadItemManager sharedInstance]insertItem:item];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    [self.view endEditing:YES];

    uploadHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    uploadHud.labelText = @"0%";
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"userid"] = [UserInfo sharedInstance].userId;
    params[@"type"] = item.property;
    params[@"startprice"] = [NSString stringWithFormat:@"%.2f",[item.price floatValue]];
    params[@"cname"] = item.name;
    params[@"feature"] = item.features;
    params[@"description"] = item.desc;
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",ServerUrl,@"company/addVerCommodity"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    request.showAccurateProgress = YES;
    request.uploadProgressDelegate = self;
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    __weak ASIFormDataRequest *weakRequest = request;
    for (NSString *key in [params allKeys]) {
        [request addPostValue:[params objectForKey:key] forKey:key];
    }
    
    for (int i = 0; i < self.images.count; i++) {
        [request addData:UIImageJPEGRepresentation(self.images[i],0.1) withFileName:[NSString stringWithFormat:@"OneItemUpload%d",i] andContentType:@"image/jpg" forKey:@"fileData"];
        [request addPostValue:[NSString stringWithFormat:@"OneItemUpload%d",i] forKey:@"fileName"];
    }
    
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:30];
    [request setCompletionBlock:^{
        AABaseJSONModelResponse *response = [[AABaseJSONModelResponse alloc]initWithString:weakRequest.responseString error:nil];
        if (response && response.result.resultCode.intValue == 0) {
            
            uploadHud.labelText = @"100%";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [uploadHud hide:NO];
                [self.view showHudAndAutoDismiss:@"审核将在两个工作日内完成"];
            });
            
            [self cleanInputs];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else{
            [self.view showHudAndAutoDismiss:response.result.msg];
        }
    }];
    [request setFailedBlock:^{
        [self.view showHudAndAutoDismiss:NetworkErrorPrompt];
    }];
    
    [request startAsynchronous];
}

-(void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes
{
    if (bytes > 0) {
        sendedBytes += (int)bytes;
        float progress = (float)sendedBytes / (float)totalBytes;
        if (progress <= 1 && progress >= 0) {
            uploadHud.labelText = [NSString stringWithFormat:@"%.0f%%",progress * 100];
        }
    }

}

-(void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength
{
    if (newLength > 0) {
        totalBytes = (int)newLength;
    }

}

-(void)textFieldTextChanged
{
    self.navigationItem.rightBarButtonItem.customButton.enabled = [self confirmButtonEnabled];
}

-(void)textViewTextDidChange
{
    self.navigationItem.rightBarButtonItem.customButton.enabled = [self confirmButtonEnabled];
}

-(void)didSelectProperty:(NSNotification *)notice
{
    self.propertyString = notice.object;
    [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    self.navigationItem.rightBarButtonItem.customButton.enabled = [self confirmButtonEnabled];
}

-(void)addImage
{
    BOOL tipShown = [[NSUserDefaults standardUserDefaults]boolForKey:@"AddImageTipShown"];
    if (!tipShown) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"选择完图片以后可以点击小图进行裁剪" message:nil delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert handleClickedButton:^(NSInteger buttonIndex) {
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AddImageTipShown"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self showImagePicker];
        }];
    }
    else{
        [self showImagePicker];
    }
}

-(void)showImagePicker
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
    picker.delegate = (id)self;
    picker.showEmptyGroups = YES;
    
    picker.maximumNumberOfSelection = 8;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark ZYQAssetPickerController delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (int i = 0; i < assets.count; i++) {
        ALAsset *asset = assets[i];
        ALAssetRepresentation *al = [asset defaultRepresentation];

        UIImage *image = [[UIImage imageWithCGImage:[al fullResolutionImage]] fixOrientationOfOrientation:al.orientation];
        NSData *jpgData = UIImageJPEGRepresentation(image, 1);
        UIImage *jpgImage = [UIImage imageWithData:jpgData];

        [self.images addObject:jpgImage];

        UploadItemImageView *imageViewItem = [[UploadItemImageView alloc]init];
        imageViewItem.image = image;
        imageViewItem.delegate = self;
        [self.imageItems addObject:imageViewItem];
        
    }
    
    [self.table reloadData];
    [self.table setContentOffset:CGPointMake(0, self.table.contentSize.height - self.table.frame.size.height) animated:YES];
    self.navigationItem.rightBarButtonItem.customButton.enabled = [self confirmButtonEnabled];

    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ImageItem delegate

-(void)tapImageItem:(UIView *)itemView
{
    NSInteger index = [self.imageItems indexOfObject:itemView];
    
    EditImageViewController *vc = [[EditImageViewController alloc]init];
    vc.image = self.images[index];
    [vc setEditImageBlock:^(UIImage *editedImage) {
        [self.images replaceObjectAtIndex:index withObject:editedImage];
        
        UploadItemImageView *itemView = [self.imageItems objectAtIndex:index];
        itemView.image = editedImage;
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)didClickDeleteImageViewItem:(UIView *)itemView
{
    
    NSInteger index = [self.imageItems indexOfObject:itemView];
    [self.images removeObjectAtIndex:index];
    [self.imageItems removeObject:itemView];

    [self.table reloadData];
    
    self.navigationItem.rightBarButtonItem.customButton.enabled = [self confirmButtonEnabled];
}

#pragma mark tableview
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    }
    else if (section == 2){
        return 3;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UploadItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    if (indexPath.section == 0){
        cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"openup_arrow"]];
        cell.textLabel.text = self.propertyString.length == 0 ? @"请选择品类" : [[self.propertyString componentsSeparatedByString:@"-"] lastObject];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = BlackColor;
    }
    else if (indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [self.nameTf removeFromSuperview];
            [cell.contentView addSubview:self.nameTf];
        }
        else if(indexPath.row == 1){
            [self.priceTf removeFromSuperview];
            [cell.contentView addSubview:self.priceTf];
        }
    }
    else if (indexPath.section == 2){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UITextField *tf = self.featuresTextFields[indexPath.row];
        [tf removeFromSuperview];
        [cell.contentView addSubview:tf];
    }
    else if (indexPath.section == 3){
        [self.descTf removeFromSuperview];
        [cell.contentView addSubview:self.descTf];
        
        CGRect frame = self.descTf.frame;
        frame.size.height = [self heightForTextViewCell];
        self.descTf.frame = frame;
    }
    else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.addImageBtn removeFromSuperview];
        [cell.contentView addSubview:self.addImageBtn];
        self.addImageBtn.frame = [self getAddImageButtonFrame];
        
        
        
        [self.imageItems enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
            obj.frame = [UploadItemImageView itemFrameAtIndex:idx];
            [cell.contentView addSubview:obj];
        }];
    }
    
    
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *v = [[UIView alloc]init];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 45)];
        label.text = @"如有疑问请拨打173-0148-1205";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = BlackColor;
        label.font = [UIFont systemFontOfSize:12];
        [v addSubview:label];
        
        if (self.index > 0) {
            UILabel *lotIndexLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 50, 20)];
            lotIndexLabel.text = [NSString stringWithFormat:@" Lot%ld",(long)self.index];
            lotIndexLabel.textColor = BlackColor;
            lotIndexLabel.font = [UIFont systemFontOfSize:14];
            lotIndexLabel.textAlignment = NSTextAlignmentCenter;
            [v addSubview:lotIndexLabel];
        }
        
        
        
        return v;
    }
    else if (section == 4) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        label.text = @"  添加图片（整张、局部、细节、落款，最多8张）";
        label.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        label.tag = 1;
        
        return label;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 45;
    }
    else if (section == 1 || section == 2 || section == 3){
        return 20;
    }
    else{
        return 40;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return [self heightForTextViewCell];
    }
    else if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
        return 44;
    }
    else{
        return CGRectGetMaxY([self getAddImageButtonFrame]) + ImageGap;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        PropertyListViewController *vc = [[PropertyListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark ScrollView delegate
-(void)keyboardWillShow:(NSNotification *)notice
{
    UITextField *currentTf = firstResponderTf;
    NSDictionary *info = [notice userInfo];
    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    
    CGRect tfFrame = [[UIApplication sharedApplication].keyWindow convertRect:currentTf.frame fromView:currentTf.superview];
    CGFloat offset = CGRectGetMaxY(tfFrame) - (Screen_Height - kbSize.height);
    if (offset > 0) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:7];
        [UIView setAnimationDuration:0.25];
        self.table.frame = CGRectMake(0, self.table.frame.origin.y - offset - 20, self.table.bounds.size.width, self.table.bounds.size.height);
        [UIView commitAnimations];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    firstResponderTf = textField;
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    firstResponderTf = (id)textView;
    return YES;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!CGRectEqualToRect(self.view.bounds, self.table.frame)) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:7];
        [UIView setAnimationDuration:0.25];
        self.table.frame = self.view.bounds;
        [UIView commitAnimations];
    }
    [self.view endEditing:YES];
    
    
    [self.table reloadData];
}

#pragma mark TextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (!CGRectEqualToRect(self.view.bounds, self.table.frame)) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:7];
        [UIView setAnimationDuration:0.25];
        self.table.frame = self.view.bounds;
        [UIView commitAnimations];
    }
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length >= 300 && range.length == 0) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)confirmButtonEnabled
{
    BOOL features = YES;
    for (UITextField *tf in self.featuresTextFields) {
        if (tf.text.length == 0) {
            features = NO;
            break;
        }
    }
    return (self.nameTf.text.length > 0 && self.priceTf.text.length > 0 && self.propertyString.length > 0 && self.images.count > 0 && features);
}

//最后一个没有图片的button的index
-(NSInteger )lastImageIndex
{
    return self.images.count;
}

-(void)cleanInputs
{
    self.nameTf.text = nil;
    self.priceTf.text = nil;
    self.descTf.text = nil;
    for (UITextField *tf in self.featuresTextFields) {
        tf.text = nil;
    }
    
    [self.images removeAllObjects];

    for (UIView *v in self.imageItems) {
        [v removeFromSuperview];
    }
    [self.imageItems removeAllObjects];
    
    self.propertyString = nil;
    
    [self.table reloadData];
    
    self.navigationItem.rightBarButtonItem.customButton.enabled = NO;
}

-(CGFloat )heightForTextViewCell
{
    CGSize textSize = [self.descTf.text boundingRectWithSize:CGSizeMake(self.descTf.frame.size.width, MAXFLOAT) options:0 | 1 attributes:@{NSFontAttributeName : self.descTf.font} context:nil].size;
    return textSize.height + 10 > 44 * 3 ? textSize.height + 10 : 44 * 3;
}

-(CGRect )getAddImageButtonFrame
{
    NSInteger count = self.images.count;
    NSInteger rows = (count - 1) / ImagesPerRow;
    NSInteger columns = (count - 1) % ImagesPerRow;
    
    
    NSInteger row;
    NSInteger column;
    
    if (columns < ImagesPerRow - 1) {
        row = rows;
        column = columns + 1;
    }
    else{
        row = rows + 1;
        column = 0;
    }
    
    CGFloat originX = ImageGap * (column + 1) + column * [UploadItemImageView imageWidth];
    CGFloat originY = ImageGap * (row    + 1) + row    * [UploadItemImageView imageWidth];
    return CGRectMake(originX, originY, [UploadItemImageView imageWidth], [UploadItemImageView imageWidth]);
}


#pragma mark Properties
-(UITextField *)nameTf
{
    if (!_nameTf) {
        _nameTf = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, Screen_Width - 30, 44)];
        _nameTf.font = [UIFont systemFontOfSize:16];
        _nameTf.delegate = self;
        _nameTf.textColor = BlackColor;
        _nameTf.placeholder = @"拍品名称(50字内)";
        _nameTf.returnKeyType = UIReturnKeyDone;
        [_nameTf addTarget:self action:@selector(textFieldTextChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _nameTf;
}

-(UITextField *)priceTf
{
    if (!_priceTf) {
        _priceTf = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, Screen_Width - 30, 44)];
        _priceTf.delegate = self;
        _priceTf.font = [UIFont systemFontOfSize:16];
        _priceTf.textColor = [UIColor colorWithRed:1 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        _priceTf.placeholder = @"预设起拍价(元)";
        _priceTf.keyboardType = UIKeyboardTypeNumberPad;
        [_priceTf addTarget:self action:@selector(textFieldTextChanged) forControlEvents:UIControlEventEditingChanged];

    }
    return _priceTf;
}

-(UITextView *)descTf
{
    if (!_descTf) {
        _descTf = [[AATextView alloc]init];
        _descTf.frame = CGRectMake(10, 0, Screen_Width - 20, 44 * 3);
        _descTf.font = [UIFont systemFontOfSize:16];
        _descTf.textColor = BlackColor;
        _descTf.backgroundColor = [UIColor clearColor];
        _descTf.placeholder = @"拍品赏析(选填，可复制粘贴，300字内)";
        _descTf.returnKeyType = UIReturnKeyDefault;
        _descTf.delegate = (id)self;
        _descTf.textContainerInset = UIEdgeInsetsMake(5, 0, 5, 0);
        [_descTf addTarget:_descTf.delegate action:@selector(textFieldTextChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _descTf;
}

-(UITableView *)table
{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _table.backgroundView = [UIView backgroundView];
        
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 20)];
        _table.tableFooterView = footerView;
        [self.view addSubview:_table];
    }
    return _table;
}

-(NSMutableArray *)featuresTextFields
{
    if (!_featuresTextFields) {
        _featuresTextFields = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < 3; i++) {
            UITextField *featureTf = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, Screen_Width - 30, 44)];
            featureTf.delegate = self;
            featureTf.font = [UIFont systemFontOfSize:16];
            featureTf.textColor = BlackColor;
            featureTf.placeholder = FeaturesPlaceholders[i];
            featureTf.returnKeyType = UIReturnKeyDone;
            [featureTf addTarget:self action:@selector(textFieldTextChanged) forControlEvents:UIControlEventEditingChanged];
            
            [_featuresTextFields addObject:featureTf];
            
            if (self.item && [self.item.features componentsSeparatedByString:@";"].count == 3) {
                featureTf.text = [[self.item.features componentsSeparatedByString:@";"][i]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
        }
    }
    return _featuresTextFields;
}

-(NSMutableArray *)imageItems
{
    if (!_imageItems) {
        _imageItems = [[NSMutableArray alloc]init];
    }
    return _imageItems;
}

-(NSMutableArray *)images
{
    if (!_images) {
        _images = [[NSMutableArray alloc]init];
    }
    return _images;
}

-(UIButton *)addImageBtn
{
    if (!_addImageBtn) {
        _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addImageBtn setBackgroundImage:[UIImage imageNamed:@"openup_person_add"] forState:UIControlStateNormal];
        _addImageBtn.layer.masksToBounds = YES;
        _addImageBtn.layer.cornerRadius = 2;
        _addImageBtn.layer.borderColor = TableViewSeparateColor.CGColor;
        _addImageBtn.layer.borderWidth = 1;
        [_addImageBtn addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addImageBtn;
}

@end
