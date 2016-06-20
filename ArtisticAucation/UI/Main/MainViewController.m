//
//  MainViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/9/9.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "MainViewController.h"
#import "AucationsViewController.h"
#import "SellerViewController.h"
#import "SearchViewController.h"
#import "PersonalCenterViewController.h"

@interface MainViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isSelectAgain;
@end

@implementation MainViewController

-(id)init
{
    if (self = [super init]) {
        AucationsViewController *vc0 = [[AucationsViewController alloc]init];
        SellerViewController *vc1 = [[SellerViewController alloc]init];
        SearchViewController *vc2 = [[SearchViewController alloc]init];
        PersonalCenterViewController *vc3 = [[PersonalCenterViewController alloc]init];
        
        UINavigationController *nav0 = [[UINavigationController alloc]initWithRootViewController:vc0];
        UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:vc1];
        UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:vc2];
        UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:vc3];
        NSArray *navigationControllers = @[nav0,nav1,nav2,nav3];
        
        NSArray *titles = @[@"拍卖",@"送拍",@"搜索",@"个人中心"];
        for (int i = 0; i < titles.count; i++) {
            NSString *normalImageName = [NSString stringWithFormat:@"tabbar_%d_icon_nor",i];
            NSString *selImageName = [NSString stringWithFormat:@"tabbar_%d_icon_sel",i];
            
            UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:titles[i] image:[UIImage imageNamed:normalImageName] selectedImage:[UIImage imageNamed:selImageName]];
            item.imageInsets = UIEdgeInsetsMake(8, 0, -8, 0);
            item.titlePositionAdjustment = UIOffsetMake(0, -2);
            
            UINavigationController *nav = navigationControllers[i];
            nav.tabBarItem = item;
            nav.interactivePopGestureRecognizer.delegate = self;
        }
        
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:204.0/255.0 green:20.0/255.0 blue:51.0/255.0 alpha:1], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
        
        self.tabBar.tintColor = [UIColor colorWithRed:204.0/255.0 green:20.0/255.0 blue:51.0/255.0 alpha:1];
        self.tabBar.barTintColor = [UIColor blackColor];
        self.tabBar.translucent = NO;
        self.viewControllers = [[NSArray alloc]initWithObjects:nav0,nav1,nav2,nav3, nil];
        
        [self.viewControllers enumerateObjectsUsingBlock:^(UINavigationController *nav, NSUInteger idx, BOOL * _Nonnull stop) {
            [nav.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[[UIImage imageNamed:@"navigation"] stretchableImageWithLeftCapWidth:5 topCapHeight:0]]];
        }];
    }
    return self;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer class] == [UIScreenEdgePanGestureRecognizer class]) {
        UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        if ([nav.visibleViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabbarController = (UITabBarController *)nav.visibleViewController;
            UINavigationController *subNav = tabbarController.selectedViewController;
            if (subNav.visibleViewController == subNav.viewControllers[0]) {
                return NO;
            }
        }
        return YES;
    }
    return YES;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if([item.title isEqualToString:@"搜索"])
    {
        if(self.isSelectAgain == NO)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:RecommendRequestNotification object:nil];
            self.isSelectAgain = YES;
        }
        else
        {
            self.isSelectAgain = YES;
        }
    }
    else
    {
        self.isSelectAgain = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.hidesBackButton = YES;
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
