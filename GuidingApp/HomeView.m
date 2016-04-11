//
//  HomeView.m
//  GuidingApp
//
//  Created by 何定飞 on 15/8/19.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import "HomeView.h"
#import "FriViewController.h"
#import "Me.h"
#import "Setting.h"
#import "Focus.h"
#import "History.h"
#import "Submit.h"

#import "MyPlanViewController.h"
#import "CommendViewController.h"
#import "AboutMeViewController.h"
#import "SearchView.h"
#import "LoginViewController.h"


@interface HomeView ()

@property (weak, nonatomic) IBOutlet UIView *mapView;   //地图视图
@property (weak, nonatomic) IBOutlet UIView *menuItemView;  //菜单项视图


@property (weak, nonatomic) IBOutlet UIButton *menuBtn;     //菜单键
@property (weak, nonatomic) IBOutlet UIButton *itemBtn1;
@property (weak, nonatomic) IBOutlet UIButton *itemBtn2;
@property (weak, nonatomic) IBOutlet UIButton *itemBtn3;
@property (weak, nonatomic) IBOutlet UIButton *itemBtn4;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;


@property (strong, nonatomic) IBOutlet UIView *mapChoiceView;   //地图选择
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *roadControl;
@property (strong, nonatomic) IBOutlet UIPickerView *mapPickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *placePickerView;
@property (weak, nonatomic) IBOutlet UILabel *placeLbl;
@property (weak, nonatomic) IBOutlet UIButton *placeBtn;
@property (weak, nonatomic) IBOutlet UITextField *mapName;
@property (weak, nonatomic) IBOutlet UITextField *placeName;

@property (weak, nonatomic) IBOutlet UIButton *ShowMapSettingBtn;
@property (weak, nonatomic) IBOutlet UIView *mapShowView;
@property (weak, nonatomic) IBOutlet UIButton *showTrafficeBtn;
@property (weak, nonatomic) IBOutlet UIButton *showLabelBtn;
@property (weak, nonatomic) IBOutlet UIButton *showScaleBtn;
@property (weak, nonatomic) IBOutlet UIButton *showCompassBtn;
@property (weak, nonatomic) IBOutlet UIButton *showMeBtn;

@property (strong, nonatomic) IBOutlet UIView *friendView;
@property (weak, nonatomic) IBOutlet UITableView *friendTableView;

@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, strong) MAPolyline *polyline;
@property (nonatomic) BOOL calRouteSuccess; // 指示是否算路成功

@end


@implementation HomeView{
    BOOL BtnsHidden;
    
    CGRect menuBtnFrame;
    
    NSArray *leftmenus;
    NSArray *mapsArray;
    NSArray *placesArray;
    
    NSString *titleItem;
    CGRect frame1;
    CGRect _orginalFrame;//用来map控制
    
    MAMapView* _customMapView;          //地图
    AMapLocationManager *_locationManager;
    CLLocationCoordinate2D *coords;
    BOOL isFirstPoint;
    UIButton * _bgBtn;
    __strong AMapNaviManager *naviManager;
    
    BOOL mapControlItemClick;
    
    NSMutableArray *spotsArray;
    NSMutableArray *friendsArray;
    NSMutableArray *collectionList;
    
    int thisPlaceId;
}

#pragma mark -liftCycle


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"首页"];
    
    [self setLeftBarItem:@selector(leftBtnClick:) image:@"dizhi" selectedImage:@"fanhuidingbu"];
    [self setRightBarItem:@selector(showFriView:) image:@"setup" selectedImage:@"rightClose"];
    
    [self viewLayout];
    [self createMapView];
    
    
    leftmenus = [[NSArray alloc]initWithObjects:@"个人中心",@"我的关注",@"我的足迹",@"我的计划",@"反馈信息", nil];
    mapsArray = [[NSArray alloc]initWithObjects:@"map1",@"map2",@"map3",@"map4",@"map5", nil];
    placesArray = [[NSArray alloc]initWithObjects:@"place1",@"place2",@"place3",@"place4",@"place5", nil];
    
    spotsArray = [[NSMutableArray alloc]init];
    friendsArray = [[NSMutableArray alloc]init];
    collectionList = [[NSMutableArray alloc]init];
    
    _annotations = [[NSMutableArray alloc]init];
    
    NSUInteger count = 2;
    thisPlaceId = 1;
    coords = malloc(count * sizeof(CLLocationCoordinate2D));
    isFirstPoint = YES;
    mapControlItemClick = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BtnsHidden = YES;
    self.fd_prefersNavigationBarHidden = NO;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - layout
- (void)viewLayout {
    _itemBtn1.translatesAutoresizingMaskIntoConstraints = YES;
    menuBtnFrame = _menuBtn.frame;
    
    //菜单项设为圆形
    [DFTools setBtnCycle:_menuItemView borderWidth:0 borderColor:[UIColor whiteColor]];
    _menuItemView.backgroundColor = DF_BackgroundColor;
    _menuItemView.alpha = 0;
    _menuItemView.transform = CGAffineTransformRotate(_menuItemView.transform, -M_PI_2*1.5);
    
    _bgBtn = [[UIButton alloc]initWithFrame:Screen_Frame];
    [_bgBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_bgBtn belowSubview:_menuItemView];
    _bgBtn.enabled = NO;
    
    _mapPickerView.backgroundColor = DF_BackgroundColor;
    _mapChoiceView.backgroundColor = DF_BackgroundColor;
    _placePickerView.backgroundColor = DF_BackgroundColor;
    _friendView.backgroundColor = DF_BackgroundColor;
    
}

#pragma mark - buttonClick_Method
/*
 *主页按钮：
 *
 */
//底部菜单项按钮
- (IBAction)menuBtnClick:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        if (BtnsHidden == YES) {
            _menuBtn.transform = CGAffineTransformMakeTranslation(-self.view.center.x + _menuBtn.frame.size.width/2, 0);
            _menuBtn.transform = CGAffineTransformRotate(_menuBtn.transform, -M_PI_4*3);
            BtnsHidden = NO;

            _menuItemView.alpha = 0.8;
            _menuItemView.transform = CGAffineTransformIdentity;

            _menuBtn.highlighted = YES;
            _bgBtn.enabled = YES;
            
        }
        else{
            _menuBtn.frame = menuBtnFrame;
            _menuBtn.transform = CGAffineTransformIdentity;
            BtnsHidden = YES;
            
            _menuItemView.alpha = 0;
            _menuItemView.transform = CGAffineTransformRotate(_menuItemView.transform, -M_PI_2*1.5);
            _menuBtn.highlighted = NO;
            _bgBtn.enabled = NO;
        }
    }];
}


//navigation左部按钮
- (void)leftBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([self.view.subviews containsObject:_mapChoiceView]) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = _mapChoiceView.frame;
            rect.origin.y = 64-222;
            _mapChoiceView.frame = rect;
            _mapChoiceView.alpha = 0;
        } completion:^(BOOL finished) {
            [_mapChoiceView removeFromSuperview];
        }];
        [btn setSelected:NO];
    }
    else {
        [self requestCollection];
        if (_customMapView.hidden) {
            [_mapTypeControl setSelectedSegmentIndex:0];
        } else {
            if (_customMapView.mapType == MAMapTypeSatellite) {
                _mapTypeControl.selectedSegmentIndex = 3;
            }
            else {
                if (_customMapView.cameraDegree == 0) {
                    _mapTypeControl.selectedSegmentIndex = 1;
                }
                if (_customMapView.cameraDegree == 45.0) {
                    _mapTypeControl.selectedSegmentIndex = 2;
                }
            }
            
        }

        _mapChoiceView.frame = CGRectMake(0, 0, 375, 222);
        _mapChoiceView.alpha = 0;
        [self.view addSubview:_mapChoiceView];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = _mapChoiceView.frame;
            rect.origin.y = 64;
            _mapChoiceView.frame = rect;
            _mapChoiceView.alpha = 0.8;
        } completion:^(BOOL finished) {
        }];
        [btn setSelected:YES];
    }
}

//navigation右部按钮
- (void)showFriView:(id)sender {
    if ([self isUserLogined]) {
        [self requestFriends];
        UIButton *btn = (UIButton *)sender;
        btn.selected = !btn.selected;
        if ([self.view.subviews containsObject:_friendView]) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect rect = _friendView.frame;
                rect.origin.x = Screen_Width;
                _friendView.frame = rect;
                _friendView.alpha = 0;
            }completion:^(BOOL finished) {
                [_friendView removeFromSuperview];
            }];
        } else {
            [self requestSpotsWithId:thisPlaceId];
            _friendView.frame = CGRectMake(Screen_Width, 64, 180, 603);
            _friendView.alpha = 0;
            [self.view addSubview:_friendView];
            [UIView animateWithDuration:0.3 animations:^{
                CGRect rect = _friendView.frame;
                rect.origin.x = Screen_Width - _friendView.frame.size.width;
                _friendView.frame = rect;
                _friendView.alpha = 1;
            }];
        }
    }
}

- (IBAction)mapChoiceBtnClick:(id)sender {
    [self setMaskOn:YES];
    _mapPickerView.frame = CGRectMake(0, Screen_Height, Screen_Width, 225);
    [self.view addSubview:_mapPickerView];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = _mapPickerView.frame;
        rect.origin.y = Screen_Height - rect.size.height;
        _mapPickerView.frame = rect;
    }];
}

- (IBAction)mapSwitch:(id)sender {
    UISegmentedControl *mapControl = (UISegmentedControl*)sender;
    switch (mapControl.selectedSegmentIndex) {
        case 0:
            _customMapView.hidden = YES;
            break;
        case 1:
            _customMapView.hidden = NO;
            _customMapView.mapType = MAMapTypeStandard;
            [_customMapView setCameraDegree:0.0 animated:YES duration:0.3];
            break;
        case 2:
            _customMapView.hidden = NO;
            _customMapView.mapType = MAMapTypeStandard;
            [_customMapView setCameraDegree:45.0f animated:YES duration:0.3];
            break;
        case 3:
            _customMapView.hidden = NO;
            [_customMapView setCameraDegree:0.0 animated:YES duration:0.3];
            _customMapView.mapType = MAMapTypeSatellite;
        default:
            break;
    }
}

- (IBAction)roadSwitch:(id)sender {
    NSMutableArray *startPoints = [[NSMutableArray alloc]init];
    NSMutableArray *endPoints = [[NSMutableArray alloc]init];
    for (SpotInfo *spot in spotsArray) {
        AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:spot.SpotPointY longitude:spot.SpotPointX];
        [startPoints addObject:startPoint];
    }
    SpotInfo *spot = [spotsArray lastObject];
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:spot.SpotPointY longitude:spot.SpotPointX];
    [endPoints addObject:endPoint];
    
    [self drawNaviLineWithStartPoints:startPoints withEndPoints:endPoints];
}



- (IBAction)navSwitch:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    if (control.selectedSegmentIndex == 0) {
        [_placeBtn setHidden:NO];
        [_placeLbl setHidden:NO];
        [_placeName setHidden:NO];
    }
    else
    {
        [_placeBtn setHidden:YES];
        [_placeLbl setHidden:YES];
        [_placeName setHidden:YES];
    }
}

- (IBAction)placeNameBtnClick:(id)sender {
    [self setMaskOn:YES];
    _placePickerView.frame = CGRectMake(0, Screen_Height, Screen_Width, 225);
    [self.view addSubview:_placePickerView];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = _placePickerView.frame;
        rect.origin.y = Screen_Height - rect.size.height;
        _placePickerView.frame = rect;
    }completion:^(BOOL finished) {
    }];
}

- (void)onBtnMask:(id)sender {
    if ([self.view.subviews containsObject:_mapPickerView]) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = _mapPickerView.frame;
            rect.origin.y = Screen_Height;
            _mapPickerView.frame = rect;
        }completion:^(BOOL finished) {
            [_mapPickerView removeFromSuperview];
            [self setMaskOn:NO];
        }];
    }
    if ([self.view.subviews containsObject:_placePickerView]) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = _placePickerView.frame;
            rect.origin.y = Screen_Height;
            _placePickerView.frame = rect;
        }completion:^(BOOL finished) {
            [_placePickerView removeFromSuperview];
            [self setMaskOn:NO];
        }];
    }
    
}

#pragma mark - UISegmentDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return collectionList.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _mapPickerView) {
//        return mapsArray[row];
        PlaceBasic *place= collectionList[row];
        return place.placeName;
    }
    else
        return placesArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == _mapPickerView) {
        PlaceBasic *place= collectionList[row];
        _mapName.text = place.placeName;
        [self requestSpotsWithId:place.placeID];
        thisPlaceId = place.placeID;
//        _mapName.text = mapsArray[row];
    }else {
        _placeName.text = placesArray[row];
    }
}



//1推荐按钮
- (IBAction)itemClick:(id)sender {
    CommendViewController *commendView = [[CommendViewController alloc]init];
    [self.navigationController pushViewController:commendView animated:YES];
    [self menuBtnClick:_menuBtn];
}

//2地图按钮
- (IBAction)item2Click:(id)sender {
    if ([self isUserLogined]) {
        MyPlanViewController *plan =[[MyPlanViewController alloc]init];
        plan.title = @"我的收藏";
        [self.navigationController pushViewController:plan animated:YES];
    }
    [self menuBtnClick:_menuBtn];
}

//3朋友按钮
- (IBAction)item3Click:(id)sender {
    if ([self isUserLogined]) {
        FriViewController *friVC = [[FriViewController alloc]init];
        [self.navigationController pushViewController:friVC animated:YES];
    }
    [self menuBtnClick:_menuBtn];
}


//4 #我的
- (IBAction)item4Click:(id)sender {
    if ([self isUserLogined]) {
        AboutMeViewController *aboutMeVC = [[AboutMeViewController alloc]init];
        [self.navigationController pushViewController:aboutMeVC animated:YES];
    }
    [self menuBtnClick:_menuBtn];
}

#pragma mark -getData
- (void)requestFriends {
    for (int i = 1; i < 4; i ++) {
        MeInfo *user = [[MeInfo alloc]init];
        user.nickName = [NSString stringWithFormat:@"好友%d",i];
        user.placeX = 39.919743 ;
        user.placeY = 116.395668;
        [friendsArray addObject:user];
    }
    [_friendTableView reloadData];
}

- (void)requestSpotsWithId:(int)placeId {
    
    [[DFNetworkManager sharedManager]request_spots_all_WithId:placeId callback:^(int tagCode, id result) {
        if (tagCode == 0) {
            return;
        }
        [spotsArray removeAllObjects];
        NSArray *array = (NSArray *)result;
        for (NSDictionary *dic in array) {
            SpotInfo *spot = [[SpotInfo alloc]init];
            [dic setJSONObjectValue:spot];
            [spotsArray addObject:spot];
        }
        EXECUTE_BLOCK_IN_MAIN_BEGIN
        [_friendTableView reloadData];
        
        SpotInfo *spot =spotsArray[0];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(spot.SpotPointY,spot.SpotPointX);
        [_customMapView setCenterCoordinate:location animated:YES];

        EXECUTE_BLOCK_END
    }];
}

- (void)requestCollection {
    [collectionList removeAllObjects];
    [[DFNetworkManager sharedManager]request_collectionListWithUserId:appDelegate.userDetailInfo.userId callback:^(int tagCode, id result) {
        if (tagCode < 0) {
            return ;
        }
        NSArray *array = (NSArray *)result;
        for (NSDictionary *dic in array) {
            PlaceBasic *basic = [[PlaceBasic alloc]init];
            [dic setJSONObjectValue:basic];
            [collectionList addObject:basic];
            [_mapPickerView reloadAllComponents];
        }
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    else {
        return spotsArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"朋友";
    }
    else
    {
        return @"景点";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        NSString *reuseId = @"HomeTable";
        HomeNavCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (cell == nil) {
            cell = LV0(@"HomeNavCell");
        }
        cell.delegate = self;
//        if (friendsArray.count > 0) {
            MeInfo *info = friendsArray[indexPath.row];
            cell.nickName.text = info.nickName;
            cell.spotBtn.tag = indexPath.row;
//        }
        return cell;

    }
    else
    {
        NSString *reuseId = @"SpotCell";
        HomeSpotCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (cell == nil) {
            cell = LV0(@"HomeSpotCell");
        }
        cell.delegate = self;
        if (spotsArray.count > 0) {
            SpotInfo *spot = spotsArray[indexPath.row];
            cell.spotName.text = spot.SpotName;
            cell.spotBtn.tag = indexPath.row;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        SpotInfo *spot =spotsArray[indexPath.row];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(spot.SpotPointY,spot.SpotPointX);
        [_customMapView setCenterCoordinate:location animated:YES];
    }
    if (indexPath.section == 0) {
        MeInfo *spot =friendsArray[indexPath.row];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(spot.placeX,spot.placeY);
        [_customMapView setCenterCoordinate:location animated:YES];
    }
}

#pragma mark - delegate
//朋友导航
- (void)spotFriInfoBtnClick:(id)sender {
    Me *meVC = [[Me alloc]init];
    [meVC setRightBarYesOrNo:NO];
    [self showViewController:meVC animated:YES];
}

- (void)spotFriNaviBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    MeInfo *spot = friendsArray[btn.tag];
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:39.913819 longitude:116.39712];//暂定一个点
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:39.919743 longitude:116.395668];
    
    NSArray *startPoints = @[startPoint];
    NSArray *endPoints   = @[endPoint];
    [self drawStartPoint:startPoint endPoint:endPoint];
    [self drawNaviLineWithStartPoints:startPoints withEndPoints:endPoints];

}

//景点导航
- (void)spotNavBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    SpotInfo *spot = spotsArray[btn.tag];
    
    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:39.913819 longitude:116.39712];//暂定一个点
    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:spot.SpotPointY longitude:spot.SpotPointX];
    
    NSArray *startPoints = @[startPoint];
    NSArray *endPoints   = @[endPoint];
    [self drawStartPoint:startPoint endPoint:endPoint];
    [self drawNaviLineWithStartPoints:startPoints withEndPoints:endPoints];
}

#pragma mark - mapController
- (IBAction)clickMeBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        //开始隐藏
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = _mapShowView.frame;
            rect.origin.y = Screen_Height;
            _mapShowView.frame = rect;
            _mapShowView.alpha = 0;
        }completion:^(BOOL finished) {
            _mapShowView.hidden = YES;
        }];
        btn.selected = NO;
    }
    else {
        //开始出现
        _mapShowView.hidden = NO;
        _mapShowView.alpha = 0;
        _showCompassBtn.selected =_customMapView.showsCompass;
        _showLabelBtn.selected = _customMapView.showsLabels;
        _showScaleBtn.selected = _customMapView.showsScale;
        _showTrafficeBtn.selected = _customMapView.showTraffic;
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = _mapShowView.frame;
            rect.origin.y = Screen_Height - _mapShowView.frame.size.height-40;
            _mapShowView.frame = rect;
            _mapShowView.alpha = 0.8;
        }completion:^(BOOL finished) {
        }];
            btn.selected = YES;
    }
    
    
}
- (IBAction)mapShowBtnClick:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (btn == _showTrafficeBtn)
    {
        _customMapView.showTraffic = !_customMapView.showTraffic;
        btn.selected = _customMapView.showTraffic;
        [self showToastView:(_customMapView.showTraffic)?@"已显示交通":@"已关闭交通"];
    }
    else if (btn == _showCompassBtn )
    {
        _customMapView.showsCompass = !_customMapView.showsCompass;
        btn.selected = _customMapView.showsCompass;
        [self showToastView:(_customMapView.showsCompass)?@"已开启指南针":@"已关闭指南针"];
    }
    else if (btn == _showLabelBtn)
    {
        _customMapView.showsLabels = !_customMapView.showsLabels;
        btn.selected = _customMapView.showsLabels;
        [self showToastView:(_customMapView.showsLabels)?@"已显示地点":@"已隐藏地点"];
    }
    else if (btn == _showScaleBtn)
    {
        _customMapView.showsScale = !_customMapView.showsScale;
        btn.selected = _customMapView.showsScale;
        [self showToastView:(_customMapView.showsScale)?@"已显示标尺":@"已隐藏标尺"];
    }
    else if (btn == _showMeBtn)
    {
        _customMapView.centerCoordinate = _customMapView.userLocation.coordinate;
        _customMapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    }
    
}

#pragma mark - Maps
- (void)createMapView {
    //新建初始化地图
    [MAMapServices sharedServices].apiKey = AMMAP_KEY;
    _customMapView = [[MAMapView alloc]initWithFrame:Screen_Frame];
    _customMapView.delegate = self;
    _customMapView.showTraffic = NO;                    //交通
    _customMapView.showsCompass = NO;                   //隐藏罗盘
    _customMapView.showsScale = NO;                     //隐藏标尺
    _customMapView.logoCenter = CGPointMake(320, 10);   //把logo隐藏
    _customMapView.compassOrigin = CGPointMake(10, 64);
    _customMapView.rotateCameraEnabled = NO;
    [_customMapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading animated:YES];  //跟随用户的位置和角度移动
    
    _customMapView.customizeUserLocationAccuracyCircleRepresentation = YES; //开启自定义精度圈
    _customMapView.distanceFilter = 15; //15米定位一次
    [self.mapView addSubview:_customMapView];
    
    
    //开启定位
    [AMapLocationServices sharedServices].apiKey = AMMAP_KEY;
    _locationManager = [[AMapLocationManager alloc]init];
    _locationManager.delegate = self;
    [_locationManager setPausesLocationUpdatesAutomatically:NO];    //允许后台更新数据，防止被挂起
    [_locationManager setAllowsBackgroundLocationUpdates:YES];    //iOS9：允许后台更新数据
    [_locationManager startUpdatingLocation];
    
    if (naviManager == nil)         //导航
    {
        [AMapNaviServices sharedServices].apiKey = AMMAP_KEY;
        naviManager = [[AMapNaviManager alloc] init];
        [naviManager setDelegate:self];
    }

}

//持续定位（获取当前位置）
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    if (isFirstPoint) {
        coords[0] = location.coordinate;
        isFirstPoint = NO;
        return;
    }
    if ((double) fabs(location.coordinate.latitude - coords[0].latitude) < 0.00001f||(double) fabs(location.coordinate.longitude - coords[0].longitude) < 0.00001f ) {
        return;
    }   //避免因为大偏移量的点
//    coords[1] = location.coordinate;
    
//    MAPolyline *line = [MAPolyline polylineWithCoordinates:coords count:2];
//    [_customMapView addOverlay:line];
//    coords[0] = location.coordinate;
}

//重写覆盖物
- (MAPolylineView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 3.f;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0.47 blue:1.0 alpha:0.9];
        
        return polylineView;
    }
    
    return nil;
}


//重写个人坐标
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    /* 自定义userLocation对应的annotationView. */
//    if ([annotation isKindOfClass:[MAUserLocation class]])
//    {
//        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
//        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
//        if (annotationView == nil)
//        {
//            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
//                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
//        }
//        annotationView.image = [UIImage imageNamed:@"userPosition"];
//        
//        return annotationView;
//    }
    return nil;
}

#pragma mark - NaviEvent
- (void)drawStartPoint:(AMapNaviPoint *)startPoint endPoint:(AMapNaviPoint *)endPoint {
    
    if (_annotations)
    {
        [_customMapView removeAnnotations:_annotations];
        self.annotations = nil;
    }
    //起点图标
    if (startPoint) {
        MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc]init];
        [startAnnotation setCoordinate:CLLocationCoordinate2DMake(startPoint.latitude, startPoint.longitude)];
        startAnnotation.title   = @"起点";
        [_annotations addObject:startAnnotation];
    }
    //终点图标
    if (endPoint) {
        MAPointAnnotation *endAnnotation = [[MAPointAnnotation alloc] init];
        [endAnnotation setCoordinate:CLLocationCoordinate2DMake(endPoint.latitude, endPoint.longitude)];
        endAnnotation.title    = @"终点";
        [_annotations addObject:endAnnotation];
    }
    [_customMapView addAnnotations:self.annotations];
}

- (void)drawNaviLineWithStartPoints:(NSArray *)startPoints withEndPoints:(NSArray *)endPoints {
    if (startPoints.count == 0 || endPoints.count == 0) {
        return;
    }
    if ([naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints])
    {
        [_customMapView addOverlay:_polyline];
        if (self.annotations.count > 0)
        {
        }
    }
}

- (void)showRouteWithNaviRoute:(AMapNaviRoute *)naviRoute
{
    if (naviRoute == nil) return;
    
    // 清除旧的overlays
    if (_polyline)
    {
        [_customMapView removeOverlay:_polyline];
        self.polyline = nil;
    }
    
    NSUInteger coordianteCount = [naviRoute.routeCoordinates count];
    CLLocationCoordinate2D coordinates[coordianteCount];
    for (int i = 0; i < coordianteCount; i++)
    {
        AMapNaviPoint *aCoordinate = [naviRoute.routeCoordinates objectAtIndex:i];
        coordinates[i] = CLLocationCoordinate2DMake(aCoordinate.latitude, aCoordinate.longitude);
    }
    
    _polyline = [MAPolyline polylineWithCoordinates:coordinates count:coordianteCount];
    [_customMapView addOverlay:_polyline];
}

- (void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error {
    [self showToastView:@"不在该景区"];
    _calRouteSuccess = NO;
}

- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager1 {
    [self showRouteWithNaviRoute:[[naviManager1 naviRoute] copy]];
    _calRouteSuccess = YES;
    
}


@end
