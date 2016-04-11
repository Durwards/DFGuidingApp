//
//  Location.m
//  GuidingApp
//
//  Created by 何定飞 on 15/8/31.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import "Location.h"
@implementation Location{
    BOOL locationIsOpen;
}
static CLLocationManager *locationManager;

+ (id)sharedLocation{
    static dispatch_once_t predicate;
    static Location *sharedLocation = nil;
    dispatch_once(&predicate, ^{
        sharedLocation = [[Location alloc]init];
    });
    return sharedLocation;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        locationIsOpen = [self isLocationOpen];
        locationManager = [[CLLocationManager alloc]init];
        locationManager.delegate = self;
        locationIsOpen = [CLLocationManager locationServicesEnabled];
        self.locationManager = locationManager;
    }
    return  self;
}

//打开系统的定位开关
- (void)openLocationSwitch{
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
}

- (BOOL)isLocationOpen{
    locationIsOpen = [CLLocationManager locationServicesEnabled];
    if (locationIsOpen) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
            || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            locationIsOpen = YES;
        }
        else
            locationIsOpen = NO;
    }
    
    return locationIsOpen;
}



#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"%d",status);
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [locationManager requestWhenInUseAuthorization];
            }
            break;
            
        default:
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations firstObject];
    NSLog(@"%lf,%lf",location.coordinate.latitude,location.coordinate.longitude);
    [locationManager stopUpdatingLocation];
}

//定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSString *errorString = nil;
    [manager stopUpdatingLocation];
    NSLog(@"location can't open ,because:%@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            locationIsOpen = NO;
            errorString = @"Access to Location Services denied by user";
            break;
        case kCLErrorLocationUnknown:
            locationIsOpen = NO;
            errorString = @"Location data unavailable";
            break;
        default:
            locationIsOpen = NO;
            errorString = @"An unknown error has occurred";
            break;
    }
    NSLog(@"%@",errorString);
}



@end
