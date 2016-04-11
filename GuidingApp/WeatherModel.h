//
//  WeatherModel.h
//  GuidingApp
//
//  Created by 何定飞 on 15/11/26.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject
@property (nonatomic,assign) int cloudId;       //天气代码
@property (nonatomic,strong) NSString *date;    //日期
@property (nonatomic,strong) NSString *tmp; //最高/最低 温度

@end

@interface WeatherDetail : WeatherModel
@property (nonatomic,strong) NSString* cloudText;
@property (nonatomic,strong) NSString* currentTmp;

@end