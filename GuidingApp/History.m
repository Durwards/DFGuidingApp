//
//  History.m
//  GuidingApp
//
//  Created by 何定飞 on 15/8/27.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import "History.h"

@interface History ()
@property (weak, nonatomic) IBOutlet UIView *myView;

@end

@implementation History

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.title = @"我的足迹";
    _myView.layer.shadowColor = [[UIColor blackColor]CGColor];
    _myView.layer.shadowOffset = CGSizeMake(10, 10);
    _myView.layer.shadowRadius = 10;
    _myView.layer.shadowOpacity = 0.8;
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
