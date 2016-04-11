//
//  PlacesViewController.m
//  GuidingApp
//
//  Created by 何定飞 on 15/11/24.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "PlacesViewController.h"
#import "PlaceIntroduceView.h"
#import "Weather.h"
#import "SpotView.h"
#import "HMSegmentedControl.h"


@interface PlacesViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) Weather *weatherView;
@property (weak, nonatomic) PlaceIntroduceView *placeIntroduceView;
@property (weak, nonatomic) SpotView *spotView;

@end

@implementation PlacesViewController {
    int placeID;
    PlaceDetail *placeInfo;
    HMSegmentedControl *_control;
    NSInteger _currentIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setRightBarItem:@"收藏" WithColor:[UIColor whiteColor] WithAction:@selector(rightbtnClick:)];
    placeInfo = [[PlaceDetail alloc]init];
    [self layoutView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarAlpha:0.2 withTextColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutView {
    _scrollView.contentSize = CGSizeMake(Screen_Width * 3, 0);
    
    
    //简介页面
    PlaceIntroduceView *placeIntroduceView = LV0(@"PlaceIntroduceView");
    self.placeIntroduceView = placeIntroduceView;
    CGRect fm = placeIntroduceView.frame;
    fm.origin.x = 0;
    placeIntroduceView.frame = fm;
    [placeIntroduceView setContentWithImages:@[] withIntroduction:@"dasdasdasd"];
    [_scrollView addSubview:placeIntroduceView];
    
    //天气页面
    Weather *weatherView = LV0(@"Weather");
    self.weatherView = weatherView;
    fm = self.weatherView.frame;
    fm.origin.x = Screen_Width;
    self.weatherView.frame = fm;
    [self.weatherView setContentWithPlace:placeInfo.PlaceCity?:@"hangzhou" withBackgroundImage:@""];
    [_scrollView addSubview:self.weatherView];
    
    //景点页面
    SpotView *spotView = LV0(@"SpotView");
    self.spotView = spotView;
    fm = self.spotView.frame;
    fm.origin.x = Screen_Width * 2;
    self.spotView.frame = fm;
    [self.spotView setContentInfoWithId:placeID];
    [_scrollView addSubview:self.spotView];
}

-(void)setPlaceWithId:(int)placeId {
    placeID = placeId;
    [self requestPlaceWithId:placeId];
}


#pragma mark - RequestEvent 
- (void)requestPlaceWithId:(int)placeId {
    [[DFNetworkManager sharedManager]request_placesWithId:placeId callback:^(int tagCode, id result) {
        if (tagCode == 0) {
            NSDictionary *dic = (NSDictionary *)result[0];
            PlaceDetail *detail = [[PlaceDetail alloc]init];
            [dic setJSONObjectValue:detail];
            placeInfo = detail;
            
            EXECUTE_BLOCK_IN_MAIN_BEGIN
            self.title = placeInfo.placeName;
            NSMutableArray *images = [[NSMutableArray alloc]init];
            if (placeInfo.place_BGImage_2x_1) {
                [images addObject:placeInfo.place_BGImage_2x_1];
            }
            if (placeInfo.place_BGImage_2x_2) {
                [images addObject:placeInfo.place_BGImage_2x_2];
            }
            if (placeInfo.place_BGImage_2x_3) {
                [images addObject:placeInfo.place_BGImage_2x_3];
            }
            [self.placeIntroduceView setContentWithImages:images withIntroduction:placeInfo.placeDetail?:@"没有简介"];
            [self.weatherView setContentWithPlace:placeInfo.PlaceCity?:@"hangzhou" withBackgroundImage:placeInfo.place_weather_bg];
            EXECUTE_BLOCK_END
        }
    }];
}

- (void)requestAddCollectionWithUserId:(int)userId withPlaceId:(int)placeId {
    [[DFNetworkManager sharedManager]request_collectionAddItemWithUserId:userId withPlaceId:placeID callback:^(int tagCode, id result) {
        if (tagCode < 0) {
            return ;
        }
        NSString *resultStr = (NSString *)result;
        if ([resultStr isEqualToString:@"success"]) {
            [self showToastView:@"收藏成功"];
        }
        else
            [self showToastView:resultStr];
    }];
}

#pragma mark - ButtonsEvnet
- (void)rightbtnClick:(id)sender {
    [self requestAddCollectionWithUserId:appDelegate.userDetailInfo.userId withPlaceId:placeID];
}

- (void)addToMyFavourite {
    
}




@end
