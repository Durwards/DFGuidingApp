//
//  Location.h
//  GuidingApp
//
//  Created by 何定飞 on 15/8/31.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject <CLLocationManagerDelegate,UIAlertViewDelegate>
@property CLLocationManager *locationManager;

+ (id)sharedLocation;
- (BOOL)isLocationOpen;
- (void)openLocationSwitch;

@end
