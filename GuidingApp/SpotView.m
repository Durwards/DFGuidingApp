//
//  SpotView.m
//  GuidingApp
//
//  Created by 何定飞 on 15/12/8.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "SpotView.h"
#import "SpotCell.h"
#import "UIImageView+WebCache.h"

@implementation SpotView
{
    NSMutableArray *spotsArray;
    __weak IBOutlet UITableView *tableview;
}

- (void)awakeFromNib {
    spotsArray = [[NSMutableArray alloc]init];
}

- (void)setContentInfoWithId:(int)placeId {
    [self requestSpotWithPlaceId:placeId];
}

- (void)requestSpotWithPlaceId:(int)placeId {
    [[DFNetworkManager sharedManager]request_spots_10_WithId:placeId callback:^(int tagCode, id result) {
        if (tagCode < 0) {
            return ;
        }
        if (tagCode) {
            NSArray *array = (NSArray *)result;
            for (NSDictionary *dic in array) {
                SpotInfo *info = [[SpotInfo alloc]init];
                [dic setJSONObjectValue:info];
                [spotsArray addObject:info];
                EXECUTE_BLOCK_IN_MAIN_BEGIN
                [tableview reloadData];
                EXECUTE_BLOCK_END
            }
        }
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSourse 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 179.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = @"SpotReuseId";
    SpotCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = LV0(@"SpotCell");
    }
    if (spotsArray.count > 0) {
        SpotInfo *info = spotsArray[indexPath.row];
        [cell.bgImage sd_setImageWithURL:[NSURL URLWithString:info.SpotImage] placeholderImage:IMG(@"unloading")];
        cell.namelbl.text = info.SpotName;
    }
    return cell;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
