//
//  Me.m
//  GuidingApp
//
//  Created by 何定飞 on 15/8/25.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import "Me.h"

@interface Me ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UIView *infoDetailView;

@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextField *detailTextField;

@property (weak, nonatomic) IBOutlet UIView *controllerView;
@property (weak, nonatomic) IBOutlet UILabel *titleText1;


@end

@implementation Me{
    UIControl *control;
    BOOL isTextfieldValueChange;
}


#pragma mark -lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [DFTools setBtnCycle:_userImage borderWidth:2 borderColor:[UIColor whiteColor]];
    [DFTools setBtnCycle:_maleBtn borderWidth:0 borderColor:DF_Color];
    [DFTools setBtnCycle:_femaleBtn borderWidth:0 borderColor:DF_Color];
    
    control = [[UIControl alloc]initWithFrame:[[UIScreen mainScreen] bounds]];

    UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    view.frame = CGRectMake(0, 0, _infoView.frame.size.width, _infoView.frame.size.height);
    [_infoView addSubview:view];
    [_infoView addSubview:_infoDetailView];

}

-(void)viewWillAppear:(BOOL)animated{
    [self setRightBarItem:@selector(editBtnClick:) image:@"write_normal" selectedImage:@"correct_normal"];
    [super viewWillAppear:animated];
    [self setNavigationBarAlpha:0.2 withTextColor:[UIColor whiteColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRightBarYesOrNo:(BOOL)yesOrNo {
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark -btnClickEvent


- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.isSelected) {
        btn.selected = NO;
        if (isTextfieldValueChange) {
            [self hideKeyboard:control];
            [self showNoticeViewPlainText:nil withContent:@"确定保存修改" withConfirmTitle:@"确定" withCancelTitle:@"取消" withNoticeMode:0 withIsWarning:NO];
        }
        else
            [self cancelEdit];
    }
    else {
        isTextfieldValueChange = NO;
        _nickName.borderStyle = UITextBorderStyleRoundedRect;
        _age.borderStyle = UITextBorderStyleRoundedRect;
        _detailTextField.borderStyle = UITextBorderStyleRoundedRect;
        _nickName.enabled = YES;
        _age.enabled = YES;
        _maleBtn.enabled = YES;
        _femaleBtn.enabled = YES;
        _detailTextField.enabled = YES;
        
        _titleText1.text = @"修改个人信息";
        [UIView animateWithDuration:0.5 animations:^{
            //        _infoView.frame = CGRectMake(0, 0, _infoView.frame.size.width, _infoView.frame.size.height);
            _infoView.transform = CGAffineTransformMakeTranslation(0, -250);
            _titleText1.transform = CGAffineTransformMakeTranslation((375-82)/2-30, 0);
        }];

        btn.selected = YES;
    }
}

//上传修改信息
- (void)clickedConfirmButton {
    [super clickedConfirmButton];
    [self cancelEdit];
}

- (IBAction)genderBtnClick:(id)sender {
    _maleBtn.layer.borderWidth = 0;
    _femaleBtn.layer.borderWidth = 0;
    UIButton *btn = (UIButton *)sender;
    if (btn == _maleBtn) {
    }
    btn.layer.borderWidth =1;
    btn.highlighted = YES;
}

- (void)cancelEdit{
    [UIView animateWithDuration:0.5 animations:^{
        _infoView.transform = CGAffineTransformIdentity;
        _titleText1.transform = CGAffineTransformIdentity;
        
        _nickName.borderStyle = UITextBorderStyleNone;
        _age.borderStyle = UITextBorderStyleNone;
        _detailTextField.borderStyle = UITextBorderStyleNone;
        _nickName.enabled = NO;
        _age.enabled = NO;
        _maleBtn.enabled = NO;
        _femaleBtn.enabled = NO;
        _detailTextField.enabled = NO;
        _titleText1.text = @"个人信息";
    }];
}

#pragma mark -UITextfielddelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [_controllerView insertSubview:control belowSubview:_nickName];
    control.tag = textField.tag;
    [control addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [textField addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventEditingChanged];
}

-(void)valueChange{
    isTextfieldValueChange = YES;
}


-(void)hideKeyboard:(id)sender{
    NSInteger tag = ((UIControl *)sender).tag;
    control.tag = 0;
    UITextField *textfield = (UITextField *)[self.view viewWithTag:tag];
    [textfield resignFirstResponder];
    [control removeFromSuperview];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [control removeFromSuperview];
    [textField resignFirstResponder];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [control removeFromSuperview];
    [textField resignFirstResponder];
    return NO;
}


@end
