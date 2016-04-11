//
//  PlaceInfo.h
//  GuidingApp
//
//  Created by 何定飞 on 15/9/1.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PlaceBasic : NSObject
@property (assign,nonatomic) int placeID;                           //景区ID
@property (strong,nonatomic) NSString *placeImage;                  //景区推荐大图
@property (strong,nonatomic) NSString *placeName;                   //景区名字
@property (strong,nonatomic) NSString *placeIntroduction;           //景区简介
@property (assign,nonatomic) int placeType;                         //景区类型
@property (assign,nonatomic) int placeLikes;                        //景区收藏数
@property (strong,nonatomic) NSString *place_Image_128_1;           //大厅小图1
@property (strong,nonatomic) NSString *place_Image_128_2;           //大厅小图2

@end

@interface PlaceDetail : PlaceBasic

@property (strong,nonatomic) NSString *PlaceCity;                   //景区所在城市
@property (strong,nonatomic) NSString *placeDetail;                   //景区详细介绍
@property (strong,nonatomic) NSString *place_BGImage_2x_1;          //景区背景1
@property (strong,nonatomic) NSString *place_BGImage_2x_2;          //景区背景2
@property (strong,nonatomic) NSString *place_BGImage_2x_3;          //景区背景3
@property (strong,nonatomic) NSString *place_weather_bg;            //天气背景
@end

@interface SpotInfo : NSObject
@property (assign,nonatomic) int placeId;                           //景区ID
@property (assign,nonatomic) int SpotId;                            //景点ID
@property (assign,nonatomic) double SpotPointX;                     //景点经度
@property (assign,nonatomic) double SpotPointY;                     //景点纬度
@property (strong,nonatomic) NSString *SpotName;                    //景点名字
@property (strong,nonatomic) NSString *SpotImage;                   //景点图片

@end