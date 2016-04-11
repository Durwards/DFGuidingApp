//
//  AppDelegate.h
//  GuidingApp
//
//  Created by 何定飞 on 15/8/19.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserInfo.h"

#define AMMAP_KEY  @"a9eea728b9bb0221cc51d162fc96e6a5"      //高德地图key
#define WEATHER_KEY @"e65fca310115f700f6697d5779961240"     //天气Key

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, weak) UINavigationController * navController;
@property (nonatomic, weak) UIViewController * viewControllerBefore;//充值或注册前所在的页面

@property (nonatomic, strong) MeInfo * userDetailInfo;//用户个人信息

@property (nonatomic, assign) BOOL applicationActive;   //界面是否活动

- (BOOL)isUserLogined;
- (void)showLoginView;

@end

