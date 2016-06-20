//
//  SearchViewController.h
//  ArtisticAucation
//
//  Created by xieran on 15/9/11.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    kType_condition,
    kType_type,
    kType_status,
} SearchKeyType;

extern NSString * const RecommendRequestNotification;

@interface SearchViewController : BaseViewController
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIScrollView *scrller;

@property (nonatomic, strong) IBOutlet UIButton *previewBut;
@property (nonatomic, strong) IBOutlet UIButton *ingBut;
@property (nonatomic, strong) IBOutlet UIButton *overBut;

@property (nonatomic, strong) IBOutlet UIButton *sureBut;

@property (nonatomic, strong) IBOutlet UIButton *smjkBut;
@property (nonatomic, strong) IBOutlet UIButton *xhdsBut;
@property (nonatomic, strong) IBOutlet UIButton *yqzbBut;
@property (nonatomic, strong) IBOutlet UIButton *zstcBut;
@property (nonatomic, strong) IBOutlet UIButton *wwscBut;
@property (nonatomic, strong) IBOutlet UIButton *sgypBut;
@property (nonatomic, strong) IBOutlet UIButton *cjzbBut;
@property (nonatomic, strong) IBOutlet UIButton *zxBut;

@end
