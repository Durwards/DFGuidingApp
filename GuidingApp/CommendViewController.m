//
//  CommendViewController.m
//  GuidingApp
//
//  Created by 何定飞 on 15/8/27.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import "CommendViewController.h"
#import "RankingViewController.h"
#import "PlacesViewController.h"
#import "SearchView.h"
#import "DFTools.h"
#import "PlaceInfo.h"

@interface CommendViewController ()
{
    IBOutlet UITableView *_tableView;
}


@end

@implementation CommendViewController{
    NSArray *titles;
    NSArray *images;
    
    NSMutableArray *typeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setRightBarItem:@selector(searchBtnClick:) image:@"search" highlightedImage:@"search"];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"推荐";
    
    titles = [[NSArray alloc]initWithObjects:@"风景",@"名胜",@"游乐", nil];
    images = [[NSArray alloc]initWithObjects:IMG(@"fenjin"),IMG(@"mingshen"),IMG(@"youle"), nil];
    
    typeArray = [[NSMutableArray alloc]init];
    
    [self requestInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSourse
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 60;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 165;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return 2;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    {
        UIView *view = LV0(@"SectionHeaderView");
        SectionHeaderView *headView = (SectionHeaderView *)view;
        
        headView.sectionTitle.text = titles[section];
        headView.sectionImg.image = images[section];
        headView._moreBtn.tag = section;
        headView.delegate = self;
        return headView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
{
        NSString *reuseID = @"CommendCellReuseIdentified";
        CommendViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if (cell == nil) {
            cell = LV0(@"CommendViewTableViewCell");
        }
        if (typeArray.count > 0) {
            PlaceBasic *leftPlace = typeArray[2*indexPath.row + 4 * (indexPath.section)];
            PlaceBasic *rightPlace = typeArray[2*indexPath.row + 1 + 4 * (indexPath.section)];
            [cell setLeftContent:leftPlace withRightContent:rightPlace];
            cell.leftBtn.tag = leftPlace.placeID;
            cell.rightBtn.tag = rightPlace.placeID;
        }
        cell.delegate = self;
        return cell;
    }
}


#pragma mark - SectionHeaderClick
- (void)moreBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    RankingViewController *rankingVC = [[RankingViewController alloc]init];
    [rankingVC setSelectedIndex:btn.tag];
    [self showViewController:rankingVC animated:YES];
}

#pragma mark - PlaceCellClick
- (void)placeCellClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    PlacesViewController *placeVC = [[PlacesViewController alloc]init];
    [placeVC setPlaceWithId:(int)btn.tag];
    [self showViewController:placeVC animated:YES];
}

#pragma mark - RequestEvnet
- (void)requestInfo {
    if (typeArray) {
        [typeArray removeAllObjects];
    }
    [[DFNetworkManager sharedManager] request_placesHallWithCallback:^(int tagCode, id result) {
        if (tagCode < 0) {
            return ;
        }
        NSDictionary *dic = (NSDictionary *)result;
        NSArray *array = [dic objectForKey:@"Type0"];
        for (NSString *str in array) {
            PlaceBasic *place = [[PlaceBasic alloc]init];
            [str setJSONObjectValue:place];
            [typeArray addObject:place];
        }
        array = [dic objectForKey:@"Type1"];
        for (NSString *str in array) {
            PlaceBasic *place = [[PlaceBasic alloc]init];
            [str setJSONObjectValue:place];
            [typeArray addObject:place];
        }
        array = [dic objectForKey:@"Type2"];
        for (NSString *str in array) {
            PlaceBasic *place = [[PlaceBasic alloc]init];
            [str setJSONObjectValue:place];
            [typeArray addObject:place];
        }
        [_tableView reloadData];
    }];
}

- (void)searchBtnClick:(id)sender {
    SearchView *searchVC = [[SearchView alloc]init];
    [self showViewController:searchVC animated:YES];
}

@end

