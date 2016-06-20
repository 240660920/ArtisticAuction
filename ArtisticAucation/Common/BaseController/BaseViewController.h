//
//  BaseViewController.h
//  ArtisticAucation
//
//  Created by xieran on 15/9/11.
//  Copyright (c) 2015年 xieran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)setNavTitle:(NSString *)title;
//navgation 自定义标题View
- (void)setCustomTitleViewWithImage:(UIImage *)image orView:(UIView *)view WithFrame:(CGRect)frame;

- (void)setLeftButtonWithNormalImage:(UIImage *)image HighlightedImage:(UIImage *)hImage target:(id)target selector:(SEL)selector;

- (void)setLeftButtonTitle:(NSString *)title image:(UIImage *)image target:(id)target selector:(SEL)selector;

- (void)setRightButtonTitle:(NSString *)title font:(UIFont *)f target:(id)target selector:(SEL)selector disabled:(BOOL)disabled;
- (void)setRightButtonImage:(UIImage *)image target:(id)target selector:(SEL)selector;

//左右带字按钮
- (void)setLeftButtonTitle:(NSString *)title font:(UIFont *)f target:(id)target selector:(SEL)selector ;
- (void)setRightButtonTitle:(NSString *)title font:(UIFont *)f target:(id)target selector:(SEL)selector;

/**
 一般用来显示出错了, 过一段时间自动消失
 
 @param      error 需要显示的文字
 */
- (void)displayErrorHUDWithText:(NSString *)error;

/**
 一般用来显示loading, 过一段时间不会消失，需要调用hideHUD方法使消失
 
 @param      text 需要显示的文字
 @see        hideHUD
 */
- (void)showLoadingHUDWithText:(NSString *)text;
/**
 隐藏loading, 一般与showLoadingHUDWithText:成对调用
 
 @see        showLoadingHUDWithText:
 */
- (void)hideHUD;


/**
 当前试图控制器出栈
 */
- (void)actionBack:(id)sender;

- (void)setRightItemEnabled:(BOOL)enabled;


-(void)itemPreferenceStateChanged:(NSNotification *)notice;

@end
