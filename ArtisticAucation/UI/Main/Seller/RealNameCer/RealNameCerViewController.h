//
//  RealNameCerViewController.h
//  ArtisticAucation
//
//  Created by Haley on 15/11/2.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "BaseViewController.h"

@interface RealNameCerViewController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *topLine;
@property (nonatomic, strong) IBOutlet UIImageView *bottonLine;

@property (nonatomic, strong) IBOutlet UITextField *textField;

@property (nonatomic, strong) IBOutlet UIButton *leftBut;
@property (nonatomic, strong) IBOutlet UIButton *rightBut;

@property (nonatomic, strong) IBOutlet UIButton *sureBut;
@end
