//
//  MyInfoViewController.h
//  ArtisticAucation
//
//  Created by xieran on 15/11/28.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressInfo.h"

@interface MyInfoViewController : BaseViewController

@property(nonatomic,copy)void(^didSelectPersonalInfoBlock)(AddressInfo *selectedPersonalInfo);

@end
