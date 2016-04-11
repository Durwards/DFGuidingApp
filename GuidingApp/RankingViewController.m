//
//  RankingViewController.m
//  GuidingApp
//
//  Created by 何定飞 on 15/11/12.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "RankingViewController.h"
#import "HMSegmentedControl.h"
#import "RankingTableCell.h"
#import "PlacesViewController.h"

@interface RankingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RankingViewController{
    HMSegmentedControl *_control;
    NSInteger _currentIndex;
    NSMutableArray *placesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"景区排行榜";
    
    _control = [[HMSegmentedControl alloc]initWithSectionTitles:@[@"风景",@"名胜",@"游乐"]];
    _control.frame = CGRectMake(0, 64, 375, 35);
    [_control addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    [_control setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
    _control.backgroundColor = [UIColor clearColor];
    [_control setSelectionStyle:HMSegmentedControlSelectionStyleBox];
    _control.selectionIndicatorColor = DF_Color;
    _control.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"helvetica" size:15]};
    [_control setSelectedSegmentIndex:_currentIndex animated:YES];
    [self.view addSubview:_control];
    
    placesArray = [[NSMutableArray alloc]init];
    
}

-  (void)changeValue:(id)sender {
    HMSegmentedControl *control = (HMSegmentedControl *)sender;
    _currentIndex = control.selectedSegmentIndex;
    [self requestPlaceWithCurrentIndex];
}

-(void)setSelectedIndex:(NSInteger)index {
    _currentIndex = index;
    [self requestPlaceWithCurrentIndex];
}

#pragma mark - RequestEvent 
- (void)requestPlaceWithCurrentIndex {
    NSString *path = [NSString stringWithFormat:@"places/type/0"];
    switch (_currentIndex) {
        case 0:
            path = [NSString stringWithFormat:@"places/type/3"];
            break;
        case 1:
            path = [NSString stringWithFormat:@"places/type/1"];
            break;
        case 2:
            path = [NSString stringWithFormat:@"places/type/2"];
            break;
        default:
            
            break;
    }
    [placesArray removeAllObjects];
    [[DFNetworkManager sharedManager] getWithPath:path withParameter:nil callback:^(int tagCode, id result){
        if (tagCode < 0) {
            return ;
        }
        NSArray *array = (NSArray *)result;
        for (NSString *str in array) {
            PlaceBasic *place = [[PlaceBasic alloc]init];
            [str setJSONObjectValue:place];
            [placesArray addObject:place];
        }
        [_tableView reloadData];
    }];

}

#pragma mark - UITableViewDelegate && UITableViewDataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return placesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = @"rankingReuseId";
    RankingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = LV0(@"RankingTableCell");
    }
    PlaceBasic *place = placesArray[indexPath.row];
    [cell setContentInfo:place];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlacesViewController *placeVC = [[PlacesViewController alloc]init];
    PlaceBasic *place = placesArray[indexPath.row];
    [placeVC setPlaceWithId:place.placeID];
    [self showViewController:placeVC animated:YES];

}



@end
