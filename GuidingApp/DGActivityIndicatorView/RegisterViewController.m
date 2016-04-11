//
//  RegisterViewController.m
//  GuidingApp
//
//  Created by 何定飞 on 15/11/23.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "RegisterViewController.h"

@implementation RegisterTextField

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 38, bounds.size.height);
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    return  CGRectMake(bounds.size.width - 38 , bounds.origin.y, 38, 38);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return  CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 38, bounds.size.height);
}

-(void)drawRect:(CGRect)rect {
    self.defaultTextAttributes = @{NSKernAttributeName : @(1.5f),NSFontAttributeName:FONTSIZE(16)};
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return nil;
}

@end

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet RegisterTextField *userNameTextField;
@property (weak, nonatomic) IBOutlet RegisterTextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet RegisterTextField *passwordTextfield2;

@end

@implementation RegisterViewController {
    UIControl* hideKeyboardControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    [self setRightBarItem:@"完成" WithColor:DF_Color WithAction:@selector(registerBtnClick:)];
    [self setRightBarItemEnable:NO];
    
    hideKeyboardControl = [[UIControl alloc]initWithFrame:Screen_Frame];
    [hideKeyboardControl addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:hideKeyboardControl belowSubview:_userNameTextField];
    
    hideKeyboardControl.hidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerBtnClick:(id)sender {
    [self hideKeyboard:hideKeyboardControl];
    NSString *temp =[_userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (temp.length < _userNameTextField.text.length) {
        [self showToastView:@"用户名不符合要求"];
        return;
    }
    temp = [_passwordTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (temp.length < _passwordTextfield.text.length) {
        [self showToastView:@"密码不符合要求"];
        return;
    }
    
    if (![_passwordTextfield.text isEqualToString:_passwordTextfield2.text]) {
        [self showToastView:@"密码输入不一致"];
        return;
    }
    
    MeInfo *info = [[MeInfo alloc]init];
    info.username = _userNameTextField.text;
    info.password = _passwordTextfield.text;
    
    [self requestRegister:info];
    
}
- (void)hideKeyboard:(UIControl*)control {
    [_userNameTextField resignFirstResponder];
    [_passwordTextfield resignFirstResponder];
    [_passwordTextfield2 resignFirstResponder];
    control.hidden = YES;
}

#pragma mark - RegisterRequest
- (void)requestRegister:(MeInfo*)info {
    if (![DFTools checkNetworkConnection]) {
        return;
    }
    
    [self showLoadingViewWithAlpha:0.8 withText:@"请稍后..."];
    [[DFNetworkManager sharedManager]request_registerWithParameter:info callback:^(int tagCode, id result){
        [self hideLoadingView];
        [NSThread sleepForTimeInterval:0.5];
        if (tagCode == 1) {
            [self showToastView:@"用户名重复"];
        }
        else if (tagCode == 0) {
            [self showToastView:@"注册成功"];
            [[NSUserDefaults standardUserDefaults] setObject:info.username forKey:DefaultUsername];
            appDelegate.userDetailInfo = info;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    hideKeyboardControl.hidden = NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _userNameTextField)
    {
        if (currentString.length >= 6 && _passwordTextfield.text.length >= 6 && _passwordTextfield2.text.length >= 6) {
            [self setRightBarItemEnable:YES];
        }
        else {
            [self setRightBarItemEnable:NO];
        }
        if ([currentString length] > 11) {
            return NO;
        }
        
        
    }
    else
    {
        if (textField == _passwordTextfield) {
            if (currentString.length >= 6 && _userNameTextField.text.length >= 6 && _passwordTextfield2.text.length >= 6) {
                [self setRightBarItemEnable:YES];
            }
            else {
                [self setRightBarItemEnable:NO];
            }
        }
        else
        {
            if (currentString.length >= 6 && _userNameTextField.text.length >= 6 && _passwordTextfield.text.length >= 6) {
                [self setRightBarItemEnable:YES];
            }
            else {
                [self setRightBarItemEnable:NO];
            }

        }

        if ([currentString length] >12) {
            return NO;
        }
    }
    return YES;
}


//返回键事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _userNameTextField) {
        [_passwordTextfield becomeFirstResponder];
    }
    else if(textField == _passwordTextfield)
    {
        [_passwordTextfield2 becomeFirstResponder];
    }
    else
    {
        [_passwordTextfield2 resignFirstResponder];
        [self registerBtnClick:nil];
    }
    return YES;
}


@end
