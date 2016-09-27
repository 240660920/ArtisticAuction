//
//  AucationHallViewController.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/20.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "AucationHallViewController.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "AAWebViewController.h"
#import "AucationItemDetailViewController.h"
#import "AucationItemsListViewController.h"

@interface AucationHallViewController ()<UIActionSheetDelegate,UIWebViewDelegate>

@property(nonatomic,retain)UIWebView *webview;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,strong)UIView *topBar;

@end

@implementation AucationHallViewController

-(id)initWithOid:(NSString *)oid agencyName:(NSString *)agencyName occasionName:(NSString *)occasionName
{
    if (self = [super init]) {
        self.oid = oid;
        self.agencyName = agencyName;
        self.occasionName = occasionName;
        
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"拍卖大厅";
    
    
    UIView *topBar = [[UIView alloc]init];
    topBar.backgroundColor = [UIColor colorWithRed:0xa0/255.0 green:0x1b/255.0 blue:0x22/255.0 alpha:1];
    self.topBar = topBar;
    
    [self.view addSubview:topBar];
    
    [topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@64);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"white_left_arrow_nor"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topBar).offset(18);
        make.width.height.equalTo(@23);
        make.bottom.equalTo(topBar).offset(-(44 - 23) / 2);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = NavigationBarTitleFont;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"拍卖大厅";
    [topBar addSubview:titleLabel];
    
    [titleLabel sizeToFit];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topBar);
        make.bottom.equalTo(topBar).offset(-(44 - titleLabel.frame.size.height) / 2);
    }];
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 23, 23);
    [rightButton setImage:[UIImage imageNamed:@"share_white"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:rightButton];
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topBar).offset(-10);
        make.bottom.equalTo(topBar).offset(-(44 - 23) / 2);
    }];
    
    
    
    
    
    switch ([UserInfo sharedInstance].loginType) {
        case kLoginTypeTraveller:
            self.url = [NSString stringWithFormat:@"%@%@?oid=%@",ServerUrl,@"Auction/hall2.html",self.oid];
            break;
        case kLoginTypeWeixin:
            self.url = [NSString stringWithFormat:@"%@%@?oid=%@&userid=%@",ServerUrl,@"Auction/hall2.html",self.oid,[UserInfo sharedInstance].userId];
            break;
        case kLoginTypePhone:
            self.url = [NSString stringWithFormat:@"%@%@?oid=%@&userid=%@&phone=%@",ServerUrl,@"Auction/hall2.html",self.oid,[UserInfo sharedInstance].userId,[UserInfo sharedInstance].phone];
            break;
        default:
            self.url = [NSString stringWithFormat:@"%@%@?oid=%@",ServerUrl,@"Auction/hall2.html",self.oid];
            break;
    }

    
    [[NSURLCache sharedURLCache]removeAllCachedResponses];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [self.webview loadRequest:request];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    if ([url rangeOfString:@"detail2.html"].length > 0) {
        AucationItemDetailViewController *vc = [[AucationItemDetailViewController alloc]init];

        NSArray *params = [[url componentsSeparatedByString:@"?"][1]componentsSeparatedByString:@"&"];
        __block NSString *cid;
        [params enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj rangeOfString:@"cid"].length > 0) {
                cid = [obj componentsSeparatedByString:@"="][1];
            }
        }];
        vc.cid = cid;
        vc.shouldHideBottomView = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    else if ([url rangeOfString:@"list2.html"].length > 0){
        AucationItemsListViewController *vc = [[AucationItemsListViewController alloc]init];
        vc.oid = self.oid;
        vc.shouldHideEnterHallBtn = YES; //隐藏进入拍场的按钮
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    return YES;
}

-(void)share
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"分享到：" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友",@"微信朋友圈", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 2) {
        int scene = buttonIndex == 0 ? WXSceneSession : WXSceneTimeline;
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = self.url;
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = [NSString stringWithFormat:@"%@拍卖大厅",self.occasionName];
        message.description = self.agencyName;
        [message setThumbImage:[UIImage imageNamed:@"icon"]];
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc]init];
        req.message = message;
        req.scene = scene;
        
        [WXApi sendReq:req];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIWebView *)webview
{
    if (!_webview) {
        _webview = [[UIWebView alloc]init];
        _webview.backgroundColor = [UIColor whiteColor];
        _webview.scalesPageToFit = YES;
        _webview.scrollView.bounces = NO;
        _webview.delegate = self;
        [self.view addSubview:_webview];
        
        [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.topBar.mas_bottom);
        }];
    }
    return _webview;
}

@end
