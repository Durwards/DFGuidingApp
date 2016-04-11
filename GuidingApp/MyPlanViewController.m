//
//  MyPlanViewController.m
//  GuidingApp
//
//  Created by 何定飞 on 15/8/27.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import "MyPlanViewController.h"
#import "CollectionTableViewCell.h"
#import "PlacesViewController.h"

@interface MyPlanViewController ()
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end

@implementation MyPlanViewController {
    NSMutableArray *collectionList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    [self setRightBarItem:@"清空" WithColor:DF_Color WithAction:@selector(rightBtnClick:)];
    
    collectionList = [[NSMutableArray alloc]init];
    [self requestCollection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDelegate && UITableViewDataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return collectionList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 107;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = @"CollectionReuseId";
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = LV0(@"CollectionTableViewCell");
    }
    if (collectionList.count >0) {
        PlaceBasic *place = collectionList[indexPath.row];
        [cell setContentInfo:place];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_listTableView deselectRowAtIndexPath:indexPath animated:YES];
    PlacesViewController *placeVC = [[PlacesViewController alloc]init];
    PlaceBasic *place = collectionList[indexPath.row];
    [placeVC setPlaceWithId:place.placeID];
    [self showViewController:placeVC animated:YES];
}

- (void)requestCollection {
    [[DFNetworkManager sharedManager]request_collectionListWithUserId:appDelegate.userDetailInfo.userId callback:^(int tagCode, id result) {
        NSArray *array = (NSArray *)result;
        for (NSDictionary *dic in array) {
            PlaceBasic *basic = [[PlaceBasic alloc]init];
            [dic setJSONObjectValue:basic];
            [collectionList addObject:basic];
            [_listTableView reloadData];
        }
    }];
}

- (void)rightBtnClick:(id)sender {
    [self showNoticeViewPlainText:@"删除" withContent:@"确定清空收藏夹" withConfirmTitle:@"确认" withCancelTitle:@"取消" withNoticeMode:0 withIsWarning:NO];
}

@end
