//
//  BottomBidView.m
//  ArtisticAucation
//
//  Created by xieran on 16/1/28.
//  Copyright © 2016年 xieran. All rights reserved.
//

#import "BottomBidView.h"

@interface BottomBidView ()<UITextFieldDelegate>
{
    CGFloat keyboardHeight;
}
@property(nonatomic,strong)UIButton *minusBtn;  //-
@property(nonatomic,strong)UIButton *addBtn;    //+
@property(nonatomic,strong)UIButton *bidBtn;    //出价
@property(nonatomic,strong)UITextField *inputTf;
@property(nonatomic,strong)UIView *backgroundView;

@property(nonatomic,strong)NSArray *priceArray;
@property(nonatomic,assign)CGRect originFrame;
@property(nonatomic,assign)NSInteger currentPrice;

@end

@implementation BottomBidView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(id)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation"]];
        
        self.minusBtn.hidden = NO;
        self.addBtn.hidden = NO;
        self.bidBtn.hidden = NO;
        self.inputTf.hidden = NO;
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDismiss:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

-(void)setItemCurrentPrice:(NSInteger)itemCurrentPrice
{
    _itemCurrentPrice = itemCurrentPrice;
    
    self.currentPrice = itemCurrentPrice;
}

#pragma mark Private Method
-(void)minus
{
    if (![FMUString isNumberVaild:self.inputTf.text] || !self.inputTf.text.length) {
        return;
    }
    else if (self.currentPrice - 100 <= self.itemCurrentPrice){
        [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:@"出价无法低于当前价格"];
        return;
    }
    
    self.currentPrice -= 100;
    
    self.inputTf.text = [NSString stringWithFormat:@"%ld",(long)self.currentPrice];
}

-(void)add
{
    if (![FMUString isNumberVaild:self.inputTf.text]) {
        return;
    }
    self.currentPrice += 100;
    self.currentPrice = self.currentPrice / 100 * 100;
    
    self.inputTf.text = [NSString stringWithFormat:@"%ld",(long)self.currentPrice];
}

-(void)bid
{
    NSString *invalidMessage = [self invalidErrorMessage];
    if (invalidMessage) {
        [[UIApplication sharedApplication].keyWindow showHudAndAutoDismiss:invalidMessage];
        return;
    }
    
    self.currentPrice = self.inputTf.text.intValue;
    
    if (self.bidBlock) {
        self.bidBlock([NSString stringWithFormat:@"%ld",(long)self.currentPrice]);
        
        [self.inputTf resignFirstResponder];
    }
}

-(NSString *)invalidErrorMessage
{
    if (![FMUString isNumberVaild:self.inputTf.text]) {
        return @"出价必须是数字";
    }
    else if (self.inputTf.text.intValue % 100 != 0){
        return @"出价必须是100的倍数";
    }
    else if (self.inputTf.text.intValue <= self.itemCurrentPrice){
        return @"出价必须高于当前价格";
    }
    return nil;
}

-(NSString *)priceStringWithPrompt
{
    return [NSString stringWithFormat:@"¥ %ld",(long)self.currentPrice];
}

-(void)tapBackground
{
    [self.inputTf resignFirstResponder];
}

#pragma mark UITextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textDidChange
{
    if (![self invalidErrorMessage]) {
        self.currentPrice = self.inputTf.text.intValue;
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([UserInfo sharedInstance].loginType == kLoginTypeTraveller) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showLoginAlert)]) {
            [self.delegate performSelector:@selector(showLoginAlert)];
        }
        return NO;
    }
    
    
    self.originFrame = self.frame;
    
    [self.superview insertSubview:self.backgroundView belowSubview:self];
    
    return YES;
}

-(void)keyboardWillChangeFrame:(NSNotification *)notice
{
    if ([self.inputTf isFirstResponder]) {
        NSDictionary *info = [notice userInfo];
        CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
        
        keyboardHeight = kbSize.height;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:7];
        [UIView setAnimationDuration:0.25];
        CGRect frame = self.originFrame;
        frame.origin.y -= kbSize.height;
        self.frame = frame;
        [UIView commitAnimations];
    }
}

-(void)keyboardWillDismiss:(NSNotification *)notice
{
    if ([self.inputTf isFirstResponder]) {
        [self.backgroundView removeFromSuperview];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:7];
        [UIView setAnimationDuration:0.25];
        self.frame = self.originFrame;
        [UIView commitAnimations];
    }
}

#pragma mark Property
-(UIButton *)minusBtn
{
    if (!_minusBtn) {
        _minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusBtn setBackgroundImage:[UIImage imageNamed:@"bid_minus_nor"] forState:UIControlStateNormal];
        [_minusBtn setBackgroundImage:[UIImage imageNamed:@"bid_minus_sel"] forState:UIControlStateHighlighted];
        [_minusBtn addTarget:self action:@selector(minus) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_minusBtn];
        
        [_minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.height.equalTo(@33);
            make.left.equalTo(@10);
            make.centerY.equalTo(self);
        }];
    }
    return _minusBtn;
}

//-(UIButton *)priceBtn
//{
//    if (!_priceBtn) {
//        _priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_priceBtn setBackgroundImage:[[UIImage imageNamed:@"bid_bg_nor"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
//        [_priceBtn setBackgroundImage:[[UIImage imageNamed:@"bid_bg_sel"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
//        [_priceBtn setTitleColor:[UIColor colorWithRed:0x51/255.0 green:0x51/255.0 blue:0x51/255.0 alpha:1] forState:UIControlStateNormal];
//        [_priceBtn addTarget:self action:@selector(showPriceTable:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_priceBtn];
//        
//        [_priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.minusBtn.mas_right).offset(5);
//            make.width.equalTo(@100);
//            make.height.equalTo(@33);
//            make.centerY.equalTo(self);
//        }];
//    }
//    return _priceBtn;
//}

-(UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"bid_add_nor"] forState:UIControlStateNormal];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"bid_add_sel"] forState:UIControlStateHighlighted];
        [_addBtn setTitleColor:[UIColor colorWithRed:0x51/255.0 green:0x51/255.0 blue:0x51/255.0 alpha:1] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addBtn];
        
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.inputTf.mas_right).offset(5);
            make.width.equalTo(@40);
            make.height.equalTo(@33);
            make.centerY.equalTo(self);
        }];
    }
    return _addBtn;
}

-(UIButton *)bidBtn
{
    if (!_bidBtn) {
        _bidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bidBtn setBackgroundColor:[UIColor colorWithRed:153.0/255.0 green:15.0/255.0 blue:38.0/255.0 alpha:1]];
        _bidBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_bidBtn setTitle:@"出价" forState:UIControlStateNormal];
        [_bidBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bidBtn.layer.masksToBounds = YES;
        _bidBtn.layer.cornerRadius = 5;
        [_bidBtn addTarget:self action:@selector(bid) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bidBtn];
        
        [_bidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.width.equalTo(@75);
            make.height.equalTo(@33);
            make.centerY.equalTo(self);
        }];
    }
    return _bidBtn;
}

-(UITextField *)inputTf
{
    if (!_inputTf) {
        _inputTf = [[UITextField alloc]init];
        _inputTf.delegate = self;
        _inputTf.keyboardType = UIKeyboardTypeNumberPad;
        _inputTf.returnKeyType = UIReturnKeyDone;
        _inputTf.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        [_inputTf setValue:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
        _inputTf.font = [UIFont systemFontOfSize:14];
        _inputTf.textAlignment = NSTextAlignmentCenter;
        _inputTf.placeholder = @"请输入价格";
        _inputTf.borderStyle = UITextBorderStyleNone;
        _inputTf.layer.masksToBounds = YES;
        [_inputTf setBackground:[[UIImage imageNamed:@"bid_bg_nor"] stretchableImageWithLeftCapWidth:5 topCapHeight:0]];
        [self addSubview:_inputTf];
        
        
        [_inputTf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.minusBtn.mas_right).offset(5);
            make.width.equalTo(@100);
            make.height.equalTo(@33);
            make.centerY.equalTo(self);
        }];
    }
    return _inputTf;
}


-(UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:self.superview.bounds];
        [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackground)]];
    }
    return _backgroundView;
}

//-(NSArray *)priceArray
//{
//    if (!_priceArray) {
//        _priceArray = @[@"100",@"500",@"1000",@"5000"];
//    }
//    return _priceArray;
//}


//-(QuickPricePickerView *)quickPickerView
//{
//    if (!_quickPickerView) {
//        _quickPickerView = [[QuickPricePickerView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _quickPickerView.alpha = 0;
//        [self.superview addSubview:_quickPickerView];
//        
//        [_quickPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.superview).offset(-50);
//            make.width.equalTo(@194);
//            make.height.equalTo(@185);
//            make.centerX.equalTo(self.superview.mas_left).offset(110);
//        }];
//        
//        _quickPickerView.priceArray = self.priceArray;
//       
//        __weak __typeof(self)weakself = self;
//        [_quickPickerView setSelectPriceBlock:^(NSInteger index) {
//            weakself.currentPrice = [weakself.priceArray[index] intValue];
//            [weakself.priceBtn setTitle:[weakself priceStringWithPrompt] forState:UIControlStateNormal];
//        }];
//    }
//    return _quickPickerView;
//}

@end
