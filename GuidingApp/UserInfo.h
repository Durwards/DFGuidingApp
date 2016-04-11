//
//  UserInfo.h
//  GuidingApp
//
//  Created by 何定飞 on 15/8/28.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (nonatomic,assign) int userId;
@property (nonatomic,strong) NSString* username;
@property (nonatomic,strong) NSString* password;
@end


@interface MeInfo : UserInfo
@property (nonatomic,strong) NSString* nickName;
@property (nonatomic,strong) NSString* placeName;
@property (nonatomic,assign) int age;
@property (nonatomic,assign) double placeX;
@property (nonatomic,assign) double placeY;
@end

