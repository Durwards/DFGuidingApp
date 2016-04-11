//
//  DFNetworkManager.m
//  GuidingApp
//
//  Created by 何定飞 on 15/11/20.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "DFNetworkManager.h"
#import "AFNetworking.h"

@implementation DFNetworkManager {
    
}
static AFHTTPRequestOperationManager *AFNHttpManager;


+ (instancetype)sharedManager {
    static DFNetworkManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[DFNetworkManager alloc]init];
    });
    return _manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        AFNHttpManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:API_BaseUrl]];
        AFNHttpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        AFNHttpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
        [AFNHttpManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [AFNHttpManager.requestSerializer setValue:[NSURL URLWithString:API_BaseUrl].absoluteString forHTTPHeaderField:@"Referer"];
        AFNHttpManager.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

- (void)postWithPath:(NSString *)path withParameter:(id)parameter callback:(CallBackBlock)block {
    [AFNHttpManager POST:path
              parameters:[parameter getDictionaryFromObject]
                 success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                     if ([responseObject valueForKey:@"tagCode"]) {
                         int tagCode = [[responseObject valueForKey:@"tagCode"]intValue];;
                         id result = [responseObject valueForKey:@"result"];
                         block(tagCode, result);
                         return ;
                     }
                     else
                     {
                         block(0,responseObject);
                         return;
                     }
                 }
                 failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                     NSLog(@"%@",error);
                     block(-999,error);
                 }];

}

- (void)getWithPath:(NSString *)path withParameter:(id)parameter callback:(CallBackBlock)block {
    [AFNHttpManager GET:path
              parameters:[parameter getDictionaryFromObject]
                 success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                     if ([responseObject valueForKey:@"tagCode"]) {
                         int tagCode = [[responseObject valueForKey:@"tagCode"]intValue];;
                         id result = [responseObject valueForKey:@"result"];
                         block(tagCode, result);
                         return ;
                     }
                     else
                     {
                         block(0,responseObject);
                         return;
                     }
                 }
                 failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                     NSLog(@"%@",error);
                     block(-999,error);
                 }];
    
}

#pragma mark -Login && Register

-(void)request_loginWithParameter:(UserInfo *)user callback:(CallBackBlock)block {
    NSString *path = @"logins";
    [self postWithPath:path withParameter:user callback:^(int tagCode, id result) {
        block(tagCode,result);
    }];
}

- (void)request_registerWithParameter:(UserInfo *)user callback:(CallBackBlock)block {
    NSString *path = @"registers";
    [self postWithPath:path withParameter:user callback:^(int tagCode, id result) {
        block(tagCode,result);
    }];
}

#pragma mark - Weather

- (void)request_weatherWithParameter:(NSString *)places callback:(CallBackBlock)block {
    NSString *httpUrl = @"http://apis.baidu.com/heweather/weather/free";
    NSString *httpArg = [NSString stringWithFormat:@"city=%@",places];
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: WEATHER_KEY forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   block(-1,error);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSError *error;
                                   id ret = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   block((int)responseCode,ret);
                               }
                           }];
    
}

#pragma mark - Places
- (void)request_placesWithId:(int)placeId callback:(CallBackBlock)block {
    NSString *path = [NSString stringWithFormat:@"places/id/%d",placeId];
    [self getWithPath:path withParameter:nil callback:^(int tagCode, id result) {
        block(tagCode,result);
    }];
}

- (void)request_placesWithName:(NSString *)placeName callback:(CallBackBlock)block {
    NSString *path = [NSString stringWithFormat:@"places/name/%@",placeName];
    [self getWithPath:path withParameter:nil callback:^(int tagCode, id result) {
        block(tagCode,result);
    }];
}

- (void)request_placesWithType:(NSInteger)typeId callback:(CallBackBlock)block {
    int a = (int)typeId;
    
    NSString *path = [NSString stringWithFormat:@"places/type/%d",a];
    [self getWithPath:path withParameter:nil callback:^(int tagCode, id result) {
        block(tagCode,result);
    }];
}

- (void)request_placesHallWithCallback:(CallBackBlock)block {
    NSString *path = @"places/tmp/1";
    [self getWithPath:path withParameter:nil callback:^(int tagCode, id result) {
        block(tagCode,result);
    }];

}
- (void)request_placesAllWithCallback:(CallBackBlock)block {
    NSString *path = @"places";
    [self getWithPath:path withParameter:nil callback:^(int tagCode, id result) {
        block(tagCode,result);
    }];
    
}

- (void)request_placesWithParameter:(NSDictionary *)parameter callback:(CallBackBlock)block {
    NSString *path = [NSString stringWithFormat:@"places"];
    [self getWithPath:path withParameter:parameter callback:^(int tagCode, id result) {
        block(tagCode,result);
    }];
}

- (void)request_spots_10_WithId:(int)placeId callback:(CallBackBlock)block {
    NSString *path = [NSString stringWithFormat:@"spots/id/%d/tmp/1",placeId];
    [self getWithPath:path withParameter:nil callback:^(int tagCode, id result) {
        block(tagCode,result);
    }];
}

- (void)request_spots_all_WithId:(int)placeId callback:(CallBackBlock)block {
    NSString *path = [NSString stringWithFormat:@"spots/id/%d",placeId];
    [self getWithPath:path withParameter:nil callback:^(int tagCode, id result) {
        block(tagCode,result);
    }];
}

- (void)request_collectionListWithUserId:(int)userId callback:(CallBackBlock)block {
    NSString *path = [NSString stringWithFormat:@"favourites/type/123/userId/%d",userId];
    [self getWithPath:path withParameter:nil callback:^(int tagCode, id result) {
        block(tagCode,result);
    }];
}
- (void)request_collectionAddItemWithUserId:(int)userId withPlaceId:(int)placeId callback:(CallBackBlock)block {
    NSString *path = [NSString stringWithFormat:@"favourites/type/add/userId/%d/placeId/%d",userId,placeId];
    [self getWithPath:path withParameter:nil callback:^(int tagCode, id result) {
        block(tagCode,result);
    }];
}

- (void)request_collectionDeleteItemWithUserId:(int)userId withPlaceId:(int)placeId callback:(CallBackBlock)block {
    NSString *path = [NSString stringWithFormat:@"favourites/type/delete/userId/%d/placeId/%d",userId,placeId];
    [self getWithPath:path withParameter:nil callback:^(int tagCode, id result) {
        block(tagCode,result);
    }];

}

@end
