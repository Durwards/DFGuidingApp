//
//  AppDelegate.m
//  GuidingApp
//
//  Created by 何定飞 on 15/8/19.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeView.h"
#import "Location.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)isUserLogined
{
    if (self.userDetailInfo.username)
        return YES;
    return NO;
}

- (void)showLoginView
{
    LoginViewController* viewController = [[LoginViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self.navController.topViewController presentViewController:navController animated:YES completion:^{
    }];
    
}

- (void)autoLogin
{
    MeInfo *info = [[MeInfo alloc]init];
    info.username = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultUsername];
    info.password = [[NSUserDefaults standardUserDefaults]objectForKey:DefaultPassword];
    NSLog(@"%@,%@",info.username,info.password);
    [[DFNetworkManager sharedManager]request_loginWithParameter:info callback:^(int tagCode, id result) {
        if (tagCode == 0) {
            NSLog(@"登录成功");
            MeInfo *info = [[MeInfo alloc]init];
            NSDictionary *dic= (NSDictionary *)result;
            [dic setJSONObjectValue:info];
            [[NSUserDefaults standardUserDefaults] setObject:info.username forKey:DefaultUsername];
            self.userDetailInfo = info;
            [NSThread sleepForTimeInterval:0.5];
        }
        else if (tagCode == 1) {
            NSLog(@"没有该用户");
        }
        else if (tagCode == 2) {
            NSLog(@"密码错误");
        }
    }];

}



#pragma mark -application lifeCycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    HomeView *view = [[HomeView alloc]init];
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:view];

    self.window.rootViewController = nv;
    
    [self autoLogin];
    
    
    
    return YES;
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*当程序将退到后台后，考虑到多个页面都有可能要做出响应，所以最好在这里发一个通知，让有需要的页面去响应这个通知*/
//    [[NSNotificationCenter defaultCenter] postNotificationName:DFApplicationResignActive object:nil userInfo:nil];
    self.applicationActive = NO;

    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //app进入后台
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*开始定位之类*/
    
    //app将进入前台
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /* 添加监听之类的。*/
    
    // 进入前台

    self.applicationActive = YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //正常退出程序
}

@end
