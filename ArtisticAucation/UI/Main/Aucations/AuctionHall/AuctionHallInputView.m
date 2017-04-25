//
//  AuctionHallInputView.m
//  ArtisticAuction
//
//  Created by xieran on 2017/4/25.
//  Copyright © 2017年 xieran. All rights reserved.
//

#import "AuctionHallInputView.h"

@interface AuctionHallInputView ()<UITextFieldDelegate>
{

}


@end

@implementation AuctionHallInputView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.chatTf.delegate = self;
}

-(BOOL)isFirstResponder
{
    return [self.chatTf isFirstResponder] || [self.priceTf isFirstResponder];
}

-(BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    
    [self.chatTf resignFirstResponder];
    [self.priceTf resignFirstResponder];
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)keyboardFrameWillChange:(NSNotification *)notice
{
    NSDictionary *userInfo = notice.userInfo;
    
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSLog(@"%@",NSStringFromCGRect(keyboardFrame));
    

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:7];
    [UIView setAnimationDuration:duration];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.superview).offset(keyboardFrame.origin.y == Screen_Height ? 0 : -keyboardFrame.size.height);
    }];

    [self.superview layoutIfNeeded];
    [UIView commitAnimations];
}

- (IBAction)priceMinus:(id)sender {
}

- (IBAction)pricePlus:(id)sender {
}

- (IBAction)switchMode:(id)sender {
    if ([self.chatTf isFirstResponder]) {
        [self.chatTf resignFirstResponder];
        
        self.chatTf.hidden = YES;
        self.priceView.hidden = NO;
        [self.switchBtn setTitle:@"聊天" forState:UIControlStateNormal];
    }
    else if ([self.priceTf isFirstResponder]){
        [self.chatTf becomeFirstResponder];
        
        self.chatTf.hidden = NO;
        self.priceView.hidden = YES;
        
        [self.switchBtn setTitle:@"出价" forState:UIControlStateNormal];
    }
    else{
        if (self.chatTf.hidden) {
            [self.chatTf becomeFirstResponder];
            
            self.chatTf.hidden = NO;
            self.priceView.hidden = YES;
            
            [self.switchBtn setTitle:@"出价" forState:UIControlStateNormal];
        }
        else{
            self.chatTf.hidden = YES;
            self.priceView.hidden = NO;
            
            [self.switchBtn setTitle:@"聊天" forState:UIControlStateNormal];
        }
    }
}
@end
