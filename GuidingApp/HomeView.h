//
//  HomeView.h
//  GuidingApp
//
//  Created by 何定飞 on 15/8/19.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAMapKit.h"
//#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

#import "DFTools.h"
#import "HomeNavCell.h"
#import "HomeSpotCell.h"


@interface HomeView : DFBaseViewController<MAMapViewDelegate,AMapLocationManagerDelegate,AMapNaviManagerDelegate, UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,HomeSpotBtnDelegate,FriBtnDelegate>

@end
