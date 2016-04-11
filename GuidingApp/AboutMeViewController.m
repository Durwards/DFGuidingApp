//
//  AboutMeViewController.m
//  GuidingApp
//
//  Created by 何定飞 on 15/11/26.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "AboutMeViewController.h"
#import "UIImageView+LBBlurredImage.h"
#import "Me.h"
#import "MyPlanViewController.h"

#import "Setting.h"

@interface AboutMeViewController ()
@property (weak, nonatomic) IBOutlet UIView *h_dividerLine;
@property (weak, nonatomic) IBOutlet UIView *v_dividerLine;
@property (weak, nonatomic) IBOutlet UIImageView *blorImage;
@property (weak, nonatomic) IBOutlet UIImageView *UserheaderImage;

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *background = IRGB(250, 250, 250);
    self.blorImage.alpha = 0.8;
    [self.blorImage setImageToBlur:background blurRadius:10 completionBlock:nil];
    
    self.UserheaderImage.layer.cornerRadius = self.UserheaderImage.frame.size.height/2;
    self.UserheaderImage.layer.borderWidth = 2;
    self.UserheaderImage.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.UserheaderImage.layer.masksToBounds = YES;
    
    self.h_dividerLine.backgroundColor = DF_BORDER_COLOR;
    self.v_dividerLine.backgroundColor = DF_BORDER_COLOR;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarAlpha:0.2 withTextColor:[UIColor whiteColor]];
}

- (void)rightbtnClick:(id)sender {
    Setting *settingView = [[Setting alloc]init];
    [self showViewController:settingView animated:YES];
}

//个人资料
- (IBAction)personalBtnClick:(id)sender {
    Me *meVC = [[Me alloc]init];
    [self showViewController:meVC animated:YES];
}

//我的喜欢
- (IBAction)favoriteBtnClick:(id)sender {
    [self rightbtnClick:sender];
}

//观看历史
- (IBAction)historyBtnClick:(id)sender {
    MyPlanViewController *planVC = [[MyPlanViewController alloc]init];
    planVC.title = @"观看历史";
    [self showViewController:planVC animated:YES];
}

//退出登录
- (IBAction)quitBtnClick:(id)sender {
    appDelegate.userDetailInfo = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
