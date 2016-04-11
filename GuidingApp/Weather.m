//
//  Weather.m
//  GuidingApp
//
//  Created by 何定飞 on 15/11/25.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "Weather.h"
#import "UIImageView+LBBlurredImage.h"
#import "UIImageView+WebCache.h"


@interface Weather ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgblorView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) IBOutlet UITableViewCell *HeaderCell;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImg;
@property (weak, nonatomic) IBOutlet UILabel *weatherLbl;
@property (weak, nonatomic) IBOutlet UILabel *nowTmpLbl;
@property (weak, nonatomic) IBOutlet UILabel *tmpMaxMinLbl;
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateLbl;

@end

@implementation Weather {
    NSMutableDictionary * all;
    NSMutableDictionary *basicDic;
    NSMutableDictionary *nowDic;
    NSArray *forecaseArray;
}

- (void)awakeFromNib {
    UIImage *background = IMG(@"weather_bg");

    self.bgImageView.image = background;
    
    self.bgblorView.alpha = 0;
    [self.bgblorView setImageToBlur:background blurRadius:10 completionBlock:nil];

    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    
    basicDic = [[NSMutableDictionary alloc]init];
    nowDic = [[NSMutableDictionary alloc]init];
    
    _nowTmpLbl.text = @"0°";
    _nowTmpLbl.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    _weatherLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    _cityLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40];
    _tmpMaxMinLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    
}


- (void)setContentWithPlace:(NSString *)place withBackgroundImage:(NSString *)imageStr {
    [self requestWeather:(NSString *)place];
    EXECUTE_BLOCK_IN_MAIN_BEGIN
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]
                        placeholderImage:IMG(@"weather_bg")
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   [self.bgblorView setImageToBlur:_bgImageView.image blurRadius:10 completionBlock:nil];
    }];

    EXECUTE_BLOCK_END
}

#pragma mark - UITableViewDelegate && UITableViewDataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 667;
    } else
        return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString * cellReuseableId = @"currentReuseId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseableId];
        if (cell == nil) {
            cell = _HeaderCell;
        }
        return cell;
    }
    else
    {
        NSString * cellReusableId = @"weatherReuseId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusableId];
        if (cell ==  nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellReusableId];
            cell.backgroundColor = [UIColor clearColor];

            cell.textLabel.text = @"dsad";
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.text = @"详细";
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
            if (forecaseArray) {
                cell.imageView.image = [self weatherWithCloudID:[[[forecaseArray[indexPath.row+1] objectForKey:@"cond"]objectForKey:@"code_d"] intValue]];
                NSString* max = [[forecaseArray[indexPath.row+1] objectForKey:@"tmp"]objectForKey:@"max"];
                NSString* min = [[forecaseArray[indexPath.row+1] objectForKey:@"tmp"]objectForKey:@"min"];
                cell.textLabel.text = [NSString stringWithFormat:@"%@°/%@°",min,max];
                cell.detailTextLabel.text = [forecaseArray[indexPath.row+1] objectForKey:@"date"];
            }
        }
        return cell;
    }
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.bgblorView.alpha = scrollView.contentOffset.y/(scrollView.contentSize.height-Screen_Height);
}


#pragma mark - RequestEvent

- (void)requestWeather:(NSString *)places {
    [[DFNetworkManager sharedManager]request_weatherWithParameter:places callback:^(int tagCode, id result) {
        if (tagCode < 0) {
            NSLog(@"%@",result);
        }
        else if (tagCode == 200) {
            NSDictionary *dic = (NSDictionary *)result;
            all = [dic objectForKey:@"HeWeather data service 3.0"];
            basicDic = [(NSArray *)[all valueForKey:@"basic"] objectAtIndex:0];
            nowDic = [(NSArray *)[all valueForKey:@"now"] objectAtIndex:0];
            forecaseArray = [[all valueForKey:@"daily_forecast"] objectAtIndex:0];
        }
        EXECUTE_BLOCK_IN_MAIN_BEGIN
        [_tableView reloadData];
        if (all) {
            int weatherCode = [[[nowDic objectForKey:@"cond"] objectForKey:@"code"]intValue];
            _weatherImg.image = [self weatherWithCloudID:weatherCode];
            _weatherLbl.text = [[nowDic objectForKey:@"cond"] objectForKey:@"txt"];
            _cityLbl.text = [basicDic objectForKey:@"city"];
            _nowTmpLbl.text = [NSString stringWithFormat:@"%@°",[nowDic objectForKey:@"tmp"]];
            _lastUpdateLbl.text = [NSString stringWithFormat:@"最后更新:%@",[[basicDic objectForKey:@"update"] objectForKey:@"loc"]];
            NSString* maxTmp = [[forecaseArray[0] objectForKey:@"tmp"] objectForKey:@"max"];
            NSString* minTmp = [[forecaseArray[0] objectForKey:@"tmp"] objectForKey:@"min"];
            
            _tmpMaxMinLbl.text = [NSString stringWithFormat:@"%@°/%@°",minTmp,maxTmp];
        }

        EXECUTE_BLOCK_END
    }];
}

- (UIImage*)weatherWithCloudID:(int)cloudID {
    if (cloudID == 100) {
        return IMG(@"weather-clear");//晴
    }
    else if (cloudID > 100 &&cloudID < 104 )
    {
        return IMG(@"weather-few");//多云
    }
    else if(cloudID == 104)
    {
        return IMG(@"weather-broken");//阴
    }
    else if(cloudID >= 200 && cloudID < 300)
    {
        return IMG(@"weather-few");//多云
    }
    else if (cloudID >=300 && cloudID < 400)
    {
        if (cloudID == 305 || cloudID == 306 || cloudID == 309) {
            return IMG(@"weather-rain");//小雨
        }
        else {
            return IMG(@"weather-tstorm");//大雨
        }
    }
    else if (cloudID >=400 && cloudID < 500)
    {
        return IMG(@"weather-snow");//雪
    }
    else if (cloudID >=500 && cloudID < 600) {
        return IMG(@"weather-mist");//大雾
    }
    else
    {
        return IMG(@"weather-clear");//晴
    }
}

@end
