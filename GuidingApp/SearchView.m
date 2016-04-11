//
//  SearchView.m
//  GuidingApp
//
//  Created by 何定飞 on 15/8/27.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import "SearchView.h"
#import "PlacesViewController.h"

@interface SearchView ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;

@end

@implementation SearchView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.title = @"搜索";
    
    for (UIButton *btn in _btns) {
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = btn.titleLabel.tintColor.CGColor;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnClick:(id)sender {
    PlacesViewController *placeVC = [[PlacesViewController alloc]init];
    [placeVC setPlaceWithId:13];
    [self showViewController:placeVC animated:YES];
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
