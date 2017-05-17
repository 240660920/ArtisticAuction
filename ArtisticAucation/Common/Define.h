//
//  Define.h
//  ArtisticAucation
//
//  Created by xieran on 15/9/12.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#ifndef ArtisticAucation_Define_h
#define ArtisticAucation_Define_h

#define TestMode

#ifdef TestMode //测试环境

#define ServerUrl @"http://www.jiahengwentou.com:8080/auction/"

#define Port @"8080"

#define UploadMinCount 0


#else  //正式环境

#define ServerUrl @"http://www.jiahengwentou.com:80/auction/"

#define Port @"80"

#define UploadMinCount 10

#endif





//上传拍品 最多-最少件数
#define UploadMaxCount 30


//weak类型转换
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//16进制色值参数转换
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//屏幕大小判断
#define iPhone4Screen [UIScreen mainScreen].bounds.size.height == 480
#define iPhone5Screen [UIScreen mainScreen].bounds.size.height == 568
#define iPhone6Screen [UIScreen mainScreen].bounds.size.height == 667
#define iPhone6PlusScreen [UIScreen mainScreen].bounds.size.height == 736

//导航栏
#define NavigationBarTitleFont [UIFont boldSystemFontOfSize:17]
#define NavigationBarTitleColor [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]
//通用的红色
#define RedColor [UIColor colorWithRed:153.0/255.0 green:15.0/255.0 blue:38.0/255.0 alpha:1]
#define RedColorWithAlpha [UIColor colorWithRed:153.0/255.0 green:15.0/255.0 blue:38.0/255.0 alpha:0.4]
//通用的黑色
#define BlackColor [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]


//tableview 分割线
#define TableViewSeparateColor [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]

//请求失败通用提示
#define NetworkErrorPrompt @"网络异常，请检查网络设置后重试"

//验证码重发间隔
#define VerificationCodeColdDurarion 60

//拍品列表圆角
#define AucationItemCornerRadius 2


#define WeixinAppId     @"wx7f03b3e0e3642f7c"
#define WeixinAppSecret @"fe933c691d064e3759b2eed7106e9870"
#define WeixinPartnerId @"1360187702"

/***通知名字****/
#define ItemPreferenceStateChanged   @"ItemPreferenceStateChanged"
#define PaymentFinishedNotification  @"PaymentFinishedNotification"
#define DidSelectSecondLevelProperty @"DidSelectSecondLevelProperty"
#define WeixinPaySuccessNotice       @"WeixinPaySuccess"
/*******/

//占位图
#define AucationItem_PlaceHolderImage [UIImage imageNamed:@"aucationItem_PlaceHolderImage"]


typedef enum : NSUInteger {
    DisplayTypeNone = -1,      //没到预展时间
    DisplayTypePreDisplay = 0, //预展中
    DisplayTypeOngoing = 1,    //拍卖中
    DisplayTypeEnded = 2,      //已结束
} DisplayState;

typedef enum : NSUInteger {
    DealNotStart = 0,
    DealOngoing = 1,
    DealFailed = 2,
    DealFinished = 3,
    DealOngoing_ = 4,
} DealState;

typedef enum : NSUInteger {
    kItemAgency,
    kItemSpecialPerformance,
    kItemAucationItem,
} ItemType;

typedef enum : NSUInteger {
    IdentityCheckStateNotCheck = 0, //未提交审核
    IdentityCheckStateFinished = 1, //审核通过
    IdentityCheckStateFailed = 2,   //审核被驳回
    IdentifyCheckStateOnChecking = 3, //正在审核 
} IdentityCertifyState;

typedef enum : NSUInteger {
    kLoginTypeNone = 0,
    kLoginTypePhone = 1,
    kLoginTypeWeixin = 2,
    kLoginTypeTraveller = 3,
} LoginType;

typedef enum : NSUInteger {
    kSearchTypeRecommend = 0,
    kSearchTypeKeyWord   = 1,
} KSearchType;

#endif
