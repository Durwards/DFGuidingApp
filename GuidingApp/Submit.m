//
//  Submit.m
//  GuidingApp
//
//  Created by 何定飞 on 15/8/27.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import "Submit.h"

@interface Submit ()

@end

@implementation Submit

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.title = @"反馈信息";
    [self showLoadingViewWithAlpha:0.4];
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
