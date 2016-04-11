//
//  LoginViewController.m
//  GuidingApp
//
//  Created by 何定飞 on 15/11/19.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"


@implementation MyTextField

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 40, bounds.origin.y, bounds.size.width - 38, bounds.size.height);
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    return  CGRectMake(bounds.size.width - 38 , bounds.origin.y, 38, 38);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return  CGRectMake(bounds.origin.x + 40, bounds.origin.y, bounds.size.width - 38, bounds.size.height);
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 5, bounds.origin.y + 7, 25 ,25);
}

-(void)drawRect:(CGRect)rect {
    self.defaultTextAttributes = @{NSKernAttributeName : @(1.5f),NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:FONTSIZE(16)};
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return nil;
}

@end


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet MyTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet MyTextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end

@implementation LoginViewController {
    UIControl *hideKeyboardControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.fd_prefersNavigationBarHidden = YES;
    
    self.title = @"登录";
    [self layoutView];
    
    
}

- (void)layoutView {
    hideKeyboardControl = [[UIControl alloc]initWithFrame:Screen_Frame];
    [hideKeyboardControl addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:hideKeyboardControl belowSubview:_userNameTextField];
    
    hideKeyboardControl.hidden = YES;
    
    self.userNameTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"用户名" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    
    self.passwordTextField.attributedPlaceholder= [[NSAttributedString alloc]initWithString:@"密码" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    
    self.userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.userNameTextField.leftView = [[UIImageView alloc]initWithImage:IMG(@"user_normal")];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = [[UIImageView alloc]initWithImage:IMG(@"password_normal")];
    
    
    
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.titleLabel.textColor = DF_Color;
    
    [self.loginBtn setBackgroundImage:DF_Button_Full_Normal forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:DF_Button_Full_Highlighted forState:UIControlStateHighlighted];
    
    [self.loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    self.userImage.layer.cornerRadius = 20;
    self.userImage.layer.masksToBounds = YES;
    
    _userNameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:DefaultUsername];

}

#pragma mark - RequestLogin
- (void)requestLogin:(UserInfo *)user {
    if (![DFTools checkNetworkConnection]) {
        return;
    }
    [self showLoadingViewWithAlpha:0.8 withText:@"登录中"];
    [[DFNetworkManager sharedManager]request_loginWithParameter:user callback:^(int tagCode, id result) {
        [self hideLoadingView];
        if (tagCode == 0) {
            [self showToastView:@"登录成功"];
            
            MeInfo *info = [[MeInfo alloc]init];
            NSDictionary *dic= (NSDictionary *)result;
            [dic setJSONObjectValue:info];
            [[NSUserDefaults standardUserDefaults] setObject:info.username forKey:DefaultUsername];
            [[NSUserDefaults standardUserDefaults] setObject:info.password forKey:DefaultPassword];
            appDelegate.userDetailInfo = info;
            [NSThread sleepForTimeInterval:0.5];
            [self backToHome:nil];
        }
        else if (tagCode == 1) {
            [self showToastView:@"没有该用户"];
        }
        else if (tagCode == 2) {
            [self showToastView:@"密码错误"];
        }
    }];
}

#pragma mark - BtnClickEvent
- (IBAction)backToHome:(id)sender {
    [self hideKeyboard:hideKeyboardControl];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)registerBtnClick:(id)sender {
    RegisterViewController *viewController = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)loginBtnClick:(id)sender {
    [self hideKeyboard:hideKeyboardControl];
    [self.view bringSubviewToFront:_backBtn];
    if (_userNameTextField.text.length < 4) {
        [self showToastView:@"用户名错误"];
        return;
    }
    if (_passwordTextField.text.length < 6) {
        [self showToastView:@"密码错误"];
    }
    UserInfo *user = [[UserInfo alloc]init];
    user.username = _userNameTextField.text;
    user.password = _passwordTextField.text;
    [self requestLogin:user];
}

- (void)hideKeyboard:(UIControl*)control {
    [_userNameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    control.hidden = YES;
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view bringSubviewToFront:_loginBtn];
    hideKeyboardControl.hidden = NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == _userNameTextField)
    {
        if ([currentString length] > 11) {
            return NO;
        }
    }
    else if (textField == _passwordTextField)
    {
        if ([currentString length] >12) {
            return NO;
        }
    }
    return YES;
}


//返回键事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _userNameTextField) {
        [_passwordTextField becomeFirstResponder];
    }
    else {
        [_passwordTextField resignFirstResponder];
        [self loginBtnClick:nil];
    }
    return YES;
}

@end
