//
//  SubmitPerformanceNameController.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/5.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "SubmitPerformanceNameController.h"
#import "OpenupSessionViewController.h"
#import "FSMediaPicker.h"
#import "ZYQAssetPickerController.h"

@interface SubmitPerformanceNameController ()<FSMediaPickerDelegate>

@property(nonatomic,strong)UITextField *tf;
@property(nonatomic,strong)UIView *tfBackground;
@property(nonatomic,strong)UIButton *imageButton;
@property(nonatomic,strong)UILabel *promptLabel;
@property(nonatomic,strong)UIImage *performanceImage;

@end

@implementation SubmitPerformanceNameController

-(void)dealloc
{
    [UserInfo sharedInstance].agencyImage = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem = [Utils rightItemWithTitle:@"下一步" target:self selector:@selector(next)];
    self.navigationItem.rightBarButtonItem.customButton.enabled = NO;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"机构名称一旦确定将无法更改，可以是企业名称或个人斋号,上传拍品经管理员审核通过后，管理员确认拍卖时间后通知委托方具体拍卖时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert handleClickedButton:^(NSInteger buttonIndex) {
        [self.tf becomeFirstResponder];
    }];

    self.title = @"开设新专场";
}

-(void)next
{
    [self submitAgency];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageButton);
        make.top.equalTo(self.imageButton.mas_bottom).offset(10);
    }];
}

-(void)submitAgency
{
    [self.view showLoadingHud];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",ServerUrl,@"company/addVerCompany"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setPostFormat:ASIMultipartFormDataPostFormat];

    [request addPostValue:[UserInfo sharedInstance].userId forKey:@"userid"];
    [request addPostValue:self.tf.text forKey:@"oname"];
    //机构图片
    [request addPostValue:@"agencyImage.jpg" forKey:@"fileName"];
    [request addData:UIImageJPEGRepresentation(self.performanceImage , 0.1) withFileName:@"agencyImage.jpg" andContentType:@"image/jpg" forKey:@"fileData"];
    [request setCompletionBlock:^{
        
        AABaseJSONModelResponse *response = [[AABaseJSONModelResponse alloc]initWithString:request.responseString error:nil];
        if (response && response.result.resultCode.intValue == 0) {
            [self.view hideAllHud];
            
            [UserInfo sharedInstance].agencyName = self.tf.text;
            [UserInfo sharedInstance].agencyImage = self.performanceImage;
            
            
            OpenupSessionViewController *vc = [[OpenupSessionViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
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

-(void)textDidChange
{
    if ([self.tf.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0 && self.performanceImage) {
        self.navigationItem.rightBarButtonItem.customButton.enabled = YES;
    }
    else{
        self.navigationItem.rightBarButtonItem.customButton.enabled = NO;
    }
}

- (void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo
{
    [self.imageButton setBackgroundImage:mediaInfo.editedImage forState:UIControlStateNormal];

    if ([self.tf.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0 && mediaInfo.editedImage) {
        self.navigationItem.rightBarButtonItem.customButton.enabled = YES;
    }
    
    self.imageButton.frame = CGRectMake(20, CGRectGetMaxY(self.tf.frame) + 20, Screen_Width - 40, Screen_Width - 40);
    
    self.promptLabel.hidden = YES;
    
    self.performanceImage = mediaInfo.editedImage;
}


-(void)pickImage
{
    FSMediaPicker *mediaPicker = [[FSMediaPicker alloc] init];
    mediaPicker.mediaType = FSMediaTypePhoto;
    mediaPicker.editMode = FSEditModeStandard;
    mediaPicker.delegate = self;
    [mediaPicker showFromView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITextField *)tf
{
    if (!_tf) {
        _tf = [[UITextField alloc]init];
        _tf.frame = CGRectMake(0, 0, Screen_Width - 40, 50);
        _tf.center = self.tfBackground.center;
        _tf.font = [UIFont systemFontOfSize:16];
        _tf.placeholder = @"请输入机构名称";
        _tf.textColor = BlackColor;
        [_tf addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_tf];
    }
    return _tf;
}

-(UIView *)tfBackground
{
    if (!_tfBackground) {
        _tfBackground = [UIView backgroundView];
        _tfBackground.frame = CGRectMake(-0.5, 30, Screen_Width - 1, 50);
        _tfBackground.layer.masksToBounds = YES;
        _tfBackground.layer.borderWidth = 0.5;
        _tfBackground.layer.borderColor = TableViewSeparateColor.CGColor;
        _tfBackground.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        [self.view addSubview:_tfBackground];
    }
    return _tfBackground;
}

-(UIButton *)imageButton
{
    if (!_imageButton) {
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _imageButton.frame = CGRectMake(20, CGRectGetMaxY(self.tf.frame) + 10, 90, 90);
        _imageButton.layer.borderWidth = 0.5;
        _imageButton.layer.borderColor = TableViewSeparateColor.CGColor;
        [_imageButton setBackgroundImage:[UIImage imageNamed:@"openup_person_add"] forState:UIControlStateNormal];
        [_imageButton addTarget:self action:@selector(pickImage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_imageButton];
    }
    return _imageButton;
}

-(UILabel *)promptLabel
{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc]init];
        _promptLabel.text = @"设置机构图片";
        _promptLabel.textColor = BlackColor;
        _promptLabel.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:_promptLabel];
    }
    return _promptLabel;
}

@end
