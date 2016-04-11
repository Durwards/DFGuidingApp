//
//  DFNetworkManager.h
//  GuidingApp
//
//  Created by 何定飞 on 15/11/20.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import <Foundation/Foundation.h>


#define API_BaseUrl @"http://www.he-define.cn/Server/"

//回调block
typedef void(^CallBackBlock)(int tagCode ,id result );

@interface DFNetworkManager : NSObject

+ (instancetype)sharedManager;

- (void)postWithPath:(NSString *)path withParameter:(id)parameter callback:(CallBackBlock)block ;
- (void)getWithPath:(NSString *)path withParameter:(id)parameter callback:(CallBackBlock)block ;

//登录注册
- (void)request_loginWithParameter:(UserInfo *)user callback:(CallBackBlock)block;
- (void)request_registerWithParameter:(UserInfo *)user callback:(CallBackBlock)block;

//天气
- (void)request_weatherWithParameter:(NSString *)places callback:(CallBackBlock)block;

//景区
- (void)request_placesWithId:(int)placeId callback:(CallBackBlock)block;
- (void)request_placesWithName:(NSString *)placeName callback:(CallBackBlock)block;
- (void)request_placesWithType:(NSInteger)typeId callback:(CallBackBlock)block;
- (void)request_placesHallWithCallback:(CallBackBlock)block;
- (void)request_placesAllWithCallback:(CallBackBlock)block;
- (void)request_placesWithParameter:(NSDictionary *)parameter callback:(CallBackBlock)block;

//景点
- (void)request_spots_10_WithId:(int)placeId callback:(CallBackBlock)block;
- (void)request_spots_all_WithId:(int)placeId callback:(CallBackBlock)block;

//收藏夹
- (void)request_collectionListWithUserId:(int)userId callback:(CallBackBlock)block;
- (void)request_collectionAddItemWithUserId:(int)userId withPlaceId:(int)placeId callback:(CallBackBlock)block;
- (void)request_collectionDeleteItemWithUserId:(int)userId withPlaceId:(int)placeId callback:(CallBackBlock)block;
@end
