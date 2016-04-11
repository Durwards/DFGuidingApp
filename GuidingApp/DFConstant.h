//
//  DFConstant.h
//  GuidingApp
//
//  Created by 何定飞 on 15/10/13.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import <Foundation/Foundation.h>

//////此处用来宏定义一些ID值(一般是API所需要的ID之类的)
//#define 




//////此处用来枚举一些类型

enum LeftNavigationItemType{
    LeftNavigationItemNone = 0,
    LeftNavigationItemBack = 1,
};//设置做导航栏按钮（0:不显示 1:显示返回）

enum Network{
    Network_None = 0,
    Network_Wifi = 1,
    Network_Mobile = 2
};



//////此处用来设置一些名字（一般用来保存key或者用来国际化)

//common
extern NSString * const HDFAppName;
extern NSString * const DFApplicationBecomeActive;
extern NSString * const DFApplicationResignActive;

//DefaultUser
extern NSString * const DefaultUsername;
extern NSString * const DefaultUserInfo;
extern NSString * const DefaultPassword;
