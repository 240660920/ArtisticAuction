//
//  AppDelegate.m
//  ArtisticAucation
//
//  Created by xieran on 15/8/27.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import <SMS_SDK/SMSSDK.h>
#import <AlipaySDK/AlipaySDK.h>
#import "APService.h"
#import "MainViewController.h"
#import "LoginManager.h"
#import "LaunchAdManager.h"

@interface AppDelegate ()<WXApiDelegate>


@end

@implementation AppDelegate

/********/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]);
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    LoginViewController *loginViewController = [[LoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginViewController];
    [nav.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[[UIImage imageNamed:@"navigation"] stretchableImageWithLeftCapWidth:5 topCapHeight:0]]];
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName : NavigationBarTitleColor , NSFontAttributeName : NavigationBarTitleFont};
    nav.navigationBarHidden = YES;;
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    
    [self requestLaunchAdImage];
    

    //微信
    [WXApi registerApp:WeixinAppId];
    //短信验证码(ShareSDK)
    [SMSSDK registerApp:@"16a0cb85c5f14" withSecret:@"7fbed5b12666a8e83de93c742b29bedc"];
    
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kJPFNetworkDidSetupNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kJPFNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kJPFNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    //推送功能
    NSDictionary *userInfo =
    [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo)
    {
        
    }
    
    application.applicationIconBadgeNumber = 0;
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                   UIUserNotificationTypeSound |
                                                   UIUserNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    
    
    //自动登录
    LoginType loginType = [UserInfo sharedInstance].loginType;
    if (loginType == kLoginTypePhone || loginType == kLoginTypeWeixin) {
        [LoginManager login:loginType autoLogin:YES params:nil successBlock:^{
            
        } failedBlock:^(NSString *errorMsg) {            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败，请重新登录" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert handleClickedButton:^(NSInteger buttonIndex) {
                [nav popToRootViewControllerAnimated:YES];
            }];
        }];
        
        MainViewController *tabbarController = [[MainViewController alloc]init];
        [nav pushViewController:tabbarController animated:NO];
    }

    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [WXApi handleOpenURL:url delegate:(id)self];
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"%@",resultDic);
        }];
        return YES;
    }
    
    [WXApi handleOpenURL:url delegate:(id)self];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

#pragma mark - 极光推送
- (void)networkDidSetup:(NSNotification *)notification {
//        NSLog(@"\n\n\n已连接...\n\n\n");
}

- (void)networkDidClose:(NSNotification *)notification {
//        NSLog(@"\n\n\n未连接...\n\n\n");
}

- (void)networkDidRegister:(NSNotification *)notification {
//        NSLog(@"\n\n\n已注册...\n\n\n");
}

- (void)networkDidLogin:(NSNotification *)notification {
//        NSLog(@"\n\n\n已登录...\n\n\n");
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler
{
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [application beginBackgroundTaskWithExpirationHandler:^{
        
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark WeiXin delegate
-(void)onReq:(BaseReq *)req
{

}

-(void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *_resp = (SendAuthResp *)resp;
        self.code = _resp.code;
        
        
        
        [[UIApplication sharedApplication].keyWindow showLoadingHud];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeixinAppId,WeixinAppSecret,self.code]]];
        __weak ASIHTTPRequest *weakRequest = request;
        [request setCompletionBlock:^{
            [[UIApplication sharedApplication].keyWindow hideAllHud];
            
            NSDictionary *rstDic = [weakRequest.responseString objectFromJSONString];
            if (rstDic[@"errcode"]) {
                [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:@"微信登录失败"];
                self.weixinLoginFailureBlock();
                return ;
            }
            
            if (rstDic[@"access_token"] && rstDic[@"openid"]) {
                NSString *openId = rstDic[@"openid"];
                self.weixinLoginSuccessBlock(openId);
                
                
            }
        }];
        [request setFailedBlock:^{
            [[UIApplication sharedApplication].keyWindow hideAllHud];
            [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:@"微信登陆失败"];
        }];
        [request startAsynchronous];
    }
    else if ([resp isMemberOfClass:[PayResp class]]){
        if (resp.errCode == 0) {
            //支付成功
            [[NSNotificationCenter defaultCenter]postNotificationName:WeixinPaySuccessNotice object:nil];
        }
        else{
            //支付失败
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

/*获取微信用户信息
-(void)requestWeixinInfo:(NSString *)accessToken openId:(NSString *)openid
{
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openid];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    __weak ASIHTTPRequest *weakRequest = request;
    [request setCompletionBlock:^{
        
        WeixinLoginResponse *response = [[WeixinLoginResponse alloc]initWithString:weakRequest.responseString error:nil];
        if (response && response.openid) {
            
            self.weixinLoginSuccessBlock(response.openid);

        }
    }];
    [request setFailedBlock:^{
        [[UIApplication sharedApplication].keyWindow hideAllHud];
        
        [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:@"登录失败，请重新登录"];
    }];
    [request startAsynchronous];
}
*/

-(void)requestLaunchAdImage
{
    [LaunchAdManager requestLaunchAdImage];
    
    [LaunchAdManager showIfNeeded];
}

@end
