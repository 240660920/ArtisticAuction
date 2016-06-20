//
//  RealNameCerViewController.m
//  ArtisticAucation
//
//  Created by Haley on 15/11/2.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "RealNameCerViewController.h"
#import "FMUString.h"
#import "AABaseJSONModelResponse.h"

@interface RealNameCerViewController ()
{
    UIImagePickerController *_pickerController;
    
    NSMutableArray *_photoArray;
    int photoTag;
}

@end

@implementation RealNameCerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"实名认证";
    
    _photoArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [_sureBut setBackgroundImage:[[UIImage imageNamed:@"red_button_nor"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [_sureBut setBackgroundImage:[[UIImage imageNamed:@"red_button_sel"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
    [_sureBut setBackgroundImage:[[UIImage imageNamed:@"red_button_disable"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateDisabled];
    
    _sureBut.enabled = NO;
    
    _leftBut.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    _leftBut.layer.borderWidth = 1.0;
    _rightBut.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    _rightBut.layer.borderWidth = 1.0;
    
    _topLine.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
    _topLine.layer.borderWidth = 0.5;
    
    _bottonLine.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0].CGColor;
    _bottonLine.layer.borderWidth = 0.5;
    
    
    [_textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventAllEditingEvents];
}

-(void)textDidChange
{
    if (_textField.text.length > 0 && _photoArray.count == 2 && [_photoArray[0][@"uploadFile"]length] > 0 && [_photoArray[1][@"uploadFile"]length] > 0) {
        self.sureBut.enabled = YES;
    }
    else{
        self.sureBut.enabled = NO;
    }
}

-(void)verifyForButton
{
    if([FMUString isEmptyString:_textField.text])
    {
        return;
    }
    __block int i = 0;
    if(_photoArray && [_photoArray count] >0)
    {
        [_photoArray enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //
            if([[obj objectForKey:@"userID"] intValue] == 1)
            {
                i = i + 1;
            }
            if([[obj objectForKey:@"userID"] intValue] == 2)
            {
                i = i + 1;
            }
        }];
    }
    
    if(i == 2)
    {
        _sureBut.enabled = YES;
    }
    else
    {
        _sureBut.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(![FMUString isEmptyString:_textField.text])
    {
        [self verifyForButton];
    }
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)actionSure:(id)sender
{
    //认证成功
    if([_textField isFirstResponder])
    {
        [_textField resignFirstResponder];
    }
    
    [self.view showLoadingHud];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    params[@"userid"] = [UserInfo sharedInstance].userId;
    params[@"realname"] = _textField.text;
    
    NSData *data1 = _photoArray[0][@"uploadFile"];
    NSData *data2 = _photoArray[1][@"uploadFile"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",ServerUrl,@"user/identificationUser"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    __weak ASIFormDataRequest *weakRequest = request;
    for (NSString *key in [params allKeys]) {
        [request addPostValue:[params objectForKey:key] forKey:key];
    }
    [request addData:data1 withFileName:@"idcard1.jpg" andContentType:@"image/jpg" forKey:@"fileData"];
    [request addData:data2 withFileName:@"idcard2.jpg" andContentType:@"image/jpg" forKey:@"fileData"];
    [request addPostValue:@"id_card1.jpg" forKey:@"fileName"];
    [request addPostValue:@"id_card2.jpg" forKey:@"fileName"];


    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:30];
    [request setCompletionBlock:^{
        AABaseJSONModelResponse *response = [[AABaseJSONModelResponse alloc]initWithString:weakRequest.responseString error:nil];
        if (response && response.result.resultCode.intValue == 0) {
            [self.view showHudAndAutoDismiss:@"审核提交成功"];
            
            [UserInfo sharedInstance].identifyCertifyState = IdentifyCheckStateOnChecking;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else{
            [self.view showHudAndAutoDismiss:@"提交失败"];
        }
    }];
    [request setFailedBlock:^{
        [self.view showHudAndAutoDismiss:NetworkErrorPrompt];
    }];
    
    [request startAsynchronous];

}

-(IBAction)personCard:(UIButton *)sender
{
    if([_textField isFirstResponder])
    {
        [_textField resignFirstResponder];
    }
    photoTag = sender.tag;
    UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:@"选取照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [aSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (UIImagePickerController *)imagePickerController {
    if (_pickerController == nil) {
        _pickerController = [[UIImagePickerController alloc] init];
        _pickerController.delegate = self;
        _pickerController.allowsEditing=YES;
    }
    return _pickerController;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    switch (buttonIndex)
    {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                [self imagePickerController].sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:[self imagePickerController] animated:YES completion:^{
                    //
                }];
            }
        }
            break;
        case 1:
        {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                [self imagePickerController].sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;//
                [self presentViewController:[self imagePickerController] animated:YES completion:^{
                    //
                }];
            }
        }
            break;
        default:
        {
        }
            break;
    }
}

#pragma mark - UIPickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //相机拍照保存本地
        UIImageWriteToSavedPhotosAlbum(image, self,nil, nil);
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        //
        if(photoTag == 1)
        {
            [self.leftBut setImage:nil forState:UIControlStateNormal];
            [self.leftBut setBackgroundImage:image forState:UIControlStateNormal];
        }
        else
        {
            [self.rightBut setImage:nil forState:UIControlStateNormal];
            [self.rightBut setBackgroundImage:image forState:UIControlStateNormal];
        }

        if(_photoArray && [_photoArray count] > 0)
        {
            [_photoArray enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                //
                if([obj objectForKey:@"userID"] == [NSNumber numberWithInt:photoTag])
                {
                    [_photoArray removeObject:obj];
                    *stop = YES;
                }
            }];
        }
        
        NSData *imageData = UIImageJPEGRepresentation([image fixOrientationOfOrientation:(NSInteger)image.imageOrientation],0.3);
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setObject:imageData forKey:@"uploadFile"];
        [param setObject:[NSNumber numberWithInt:photoTag] forKey:@"userID"];
        
        [_photoArray addObject:param];
        [self verifyForButton];
        
    }];
    _pickerController = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        //
        _pickerController = nil;
    }];
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
