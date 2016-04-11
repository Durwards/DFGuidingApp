//
//  PlaceInfo.m
//  GuidingApp
//
//  Created by 何定飞 on 15/9/1.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import "PlaceInfo.h"

@implementation PlaceBasic
@synthesize placeID;
@synthesize placeImage;
@synthesize placeName;
@synthesize placeIntroduction;
@synthesize placeType;
@synthesize placeLikes;

@end

@implementation PlaceDetail
@synthesize PlaceCity;
@synthesize placeDetail;
@synthesize place_BGImage_2x_1;
@synthesize place_BGImage_2x_2;
@synthesize place_BGImage_2x_3;
@synthesize place_weather_bg;

@end

@implementation SpotInfo
@synthesize placeId;
@synthesize SpotId;
@synthesize SpotPointX;
@synthesize SpotPointY;
@synthesize SpotName;
@synthesize SpotImage;

@end