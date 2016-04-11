//
//  DFTools.m
//  GuidingApp
//
//  Created by 何定飞 on 15/8/25.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import "Reachability.h"
#import "DFToastView.h"


@implementation DFObject

- (id)initWithUserData:(id)userData
{
    self = [super init];
    if (self)
    {
        _userData = userData;
    }
    return self;
}
@end


/////////////////////////

@implementation DFTools
+(id)sharedInstance{
    static DFTools *sharedMytools = nil;
    static dispatch_once_t *predicate;
    dispatch_once(predicate, ^{
        sharedMytools = [[DFTools alloc]init];
    });
    return sharedMytools;

}


+(void)setBtnCycle:(id)sender borderWidth:(float)width borderColor:(UIColor *)color{
    UIView *view = (UIView *)sender;
    view.layer.cornerRadius = view.frame.size.height/2;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = width;
    view.layer.borderColor = [color CGColor];
}

+ (BOOL)checkNetworkConnection
{
    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable &&
        [Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable)
    {
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        DFToastView* toast = [[DFToastView alloc] initWithParentView:appDelegate.window
                                                             andText:@"似乎没有网络~"];
        [toast setYOffset:100];
        [toast show];
        return NO;
    }
    return YES;
}

+ (BOOL)isNetworkConnection
{
    if ([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable &&
        [Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable)
        return NO;
    return YES;
}
+ (BOOL) is3GWifi
{
    // 获取手机信号栏上面的网络类型的标志
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews)
    {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])
        {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    NSNumber* num = [dataNetworkItemView valueForKey:@"dataNetworkType"];// 0 = No wifi or cellular；1 = 2G；2 = 3G；3 = 4G；4 = LTE；5 = Wifi
    
    if ([num intValue] >= 2)
        return YES;
    
    return NO;
}

+ (BOOL) is4GWifiOrHigher
{
    // 获取手机信号栏上面的网络类型的标志
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews)
    {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])
        {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    NSNumber* num = [dataNetworkItemView valueForKey:@"dataNetworkType"];// 0 = No wifi or cellular；1 = 2G；2 = 3G；3 = 4G；4 = LTE；5 = Wifi
    
    if ([num intValue] >= 3)
        return YES;
    
    return NO;
}

+ (int)checkNetworkState
{
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable)
    { // 有wifi
        return Network_Wifi;
    }
    else if ([conn currentReachabilityStatus] != NotReachable)
    { // 没有使用wifi, 使用手机自带网络进行上网
        return Network_Mobile;
    } else { // 没有网络
        return Network_None;
    }
}




+ (BOOL) isPureNumberWithText:(NSString *)text
{
    if (![[text stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]]trim].length >0)
    {
        return YES;
    }
    return NO;
}

+ (BOOL) isPureEnglishWithText:(NSString *)text
{
    if (![[text stringByTrimmingCharactersInSet: [NSCharacterSet letterCharacterSet]]trim].length >0)
    {
        return YES;
    }
    return NO;
}




+ (BOOL)isIOS5
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_1)
    {
        return NO;
    }
    if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_5_0)
    {
        return NO;
    }
    return YES;
}

+ (BOOL)isIOS5orLower
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_5_1)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isIOS5orHigher
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_4_3)
    {
        return NO;
    }
    return YES;
}

+ (BOOL)isIOS6
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_5_1)
        return NO;
    
    if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_7_0)
        return NO;
    
    return YES;
}

+ (BOOL)isIOS7
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
        return NO;
    else
        return YES;
}

+ (BOOL)isIOS7orHigher
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
        return NO;
    
    return YES;
}

+ (BOOL)isIOS8orHigher
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
        return NO;
    
    return YES;
}

+ (BOOL)isIOS9orHigher
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_8_3)
        return NO;
    
    return YES;
}

+ (BOOL)isInch3_5
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (bounds.size.height == 480) {
        return YES;
    }
    return NO;
}

+ (BOOL)isInch4
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (bounds.size.height >= 568) {
        return YES;
    }
    return NO;
}

+(BOOL)checkAppInstalled:(NSString *)urlSchemes
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlSchemes]])
    {
        return  YES;
    }
    else
    {
        return  NO;
    }
}

+(BOOL)isSystemLanguageChinese
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([self isIOS9orHigher])
    {
        if ([currentLanguage isEqualToString:@"zh-Hans-CN"] || [currentLanguage isEqualToString:@"zh-Hant-CN"])
        {
            return YES;
        }
    }
    else
    {
        if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"])
        {
            return YES;
        }
    }
    return NO;
}

//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,152,157,158,159,182,187,188,147，17
     * 联通：130,131,132,155,156,185,186
     * 电信：133,1349,153,180,189
     * 13、15、18三个号段共30个号段，154、181、183、184暂时没有，加上147共27个。
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|7[0-9])\\d{8}$";
    /**
     10         * CM 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[0127-9]|8[278]|47)\\d)\\d{7}$";
    /**
     15         * CU 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[56]|8[56]|7[0-9])\\d{8}$";
    /**
     20         * CT 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * PHS 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isTodayWithTimeInterval:(NSTimeInterval)tmDate
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:tmDate];
    
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
    | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents * tmpComps = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date]];
    [tmpComps setHour:0];
    [tmpComps setMinute:0];
    [tmpComps setSecond:0];
    NSDate* date1 = [[NSCalendar currentCalendar] dateFromComponents:tmpComps];
    NSDate* date2 = [date1 dateByAddingTimeInterval:60*60*24];
    
    if ([date compare:date1] != NSOrderedAscending && [date compare:date2] == NSOrderedAscending)
    {
        return YES;
    }
    return NO;
}

/*a.本日的，显示“hh:mm”；
 b.隔一天的，显示“昨天hh:mm” 或者 “明天hh:mm”；
 c.本年内的，显示“MM/DD hh:mm”；
 d.非本年的，显示“YYYY/MM/DD hh:mm”。*/
+ (NSString *)formatTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate *localDate = [NSDate date];
    NSDictionary *localDateDic = [self getDateDicFromDate:localDate];
    NSDictionary *dateDic = [self getDateDicFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    
    if ([[localDateDic objectForKey:@"yyyy"] isEqual:[dateDic objectForKey:@"yyyy"]] && [[localDateDic objectForKey:@"MM"] isEqual:[dateDic objectForKey:@"MM"]] && [[localDateDic objectForKey:@"dd"] isEqual:[dateDic objectForKey:@"dd"]])
    {
        return [NSString stringWithFormat:@"%@:%@",[dateDic objectForKey:@"HH"],[dateDic objectForKey:@"mm"]];
    }
    else
    {
        NSInteger dayInt = 0;
        NSString *oneDayStr = nil;
        if (timeInterval > localDate.timeIntervalSince1970) {
            dayInt = (timeInterval - localDate.timeIntervalSince1970) / (60 * 60 * 24);
            if ([[dateDic objectForKey:@"MM"] isEqualToString:[localDateDic objectForKey:@"MM"]]) {
                dayInt = [[dateDic objectForKey:@"dd"] integerValue] - [[localDateDic objectForKey:@"dd"] integerValue];
            } else {
                CGFloat dayFloat = (timeInterval - localDate.timeIntervalSince1970) / (60 * 60 * 24);
                NSInteger dayInt = (timeInterval - localDate.timeIntervalSince1970) / (60 * 60 * 24);
                dayInt = ((dayFloat - dayInt) * 24 * 60 > (24 * 60 - ([[localDateDic objectForKey:@"HH"] integerValue] * 60 + [[localDateDic objectForKey:@"mm"] integerValue]))) ? (dayInt + 1):(dayInt);
            }
            oneDayStr = @"明天";
        } else {
            dayInt = (localDate.timeIntervalSince1970 - timeInterval) / (60 * 60 * 24);
            if ([[dateDic objectForKey:@"MM"] isEqualToString:[localDateDic objectForKey:@"MM"]]) {
                dayInt = [[localDateDic objectForKey:@"dd"] integerValue] - [[dateDic objectForKey:@"dd"] integerValue];
            } else {
                CGFloat dayFloat = (localDate.timeIntervalSince1970 - timeInterval) / (60 * 60 * 24);
                NSInteger dayInt = (localDate.timeIntervalSince1970 - timeInterval) / (60 * 60 * 24);
                dayInt = ((dayFloat - dayInt) * 24 * 60 > [[localDateDic objectForKey:@"HH"] integerValue]*60 + [[localDateDic objectForKey:@"mm"] integerValue]) ? (dayInt + 1):(dayInt);
            }
            oneDayStr = @"昨天";
        }
        
        if((long)dayInt>1)
        {
            if ([[localDateDic objectForKey:@"yyyy"] isEqual:[dateDic objectForKey:@"yyyy"]]) {
                if ([self isSystemLanguageChinese])
                {
                    return [NSString stringWithFormat:LS(@"%@/%@ %@:%@"),
                            [dateDic objectForKey:@"MM"],
                            [dateDic objectForKey:@"dd"],
                            [dateDic objectForKey:@"HH"],
                            [dateDic objectForKey:@"mm"]];
                } else {
                    return [NSString stringWithFormat:LS(@"%@/%@ %@:%@"),
                            [dateDic objectForKey:@"dd"],
                            [dateDic objectForKey:@"MM"],
                            [dateDic objectForKey:@"HH"],
                            [dateDic objectForKey:@"mm"]];
                }
            } else {
                if ([self isSystemLanguageChinese])
                {
                    return [NSString stringWithFormat:LS(@"%@/%@/%@ %@:%@"),
                            [dateDic objectForKey:@"yyyy"],
                            [dateDic objectForKey:@"MM"],
                            [dateDic objectForKey:@"dd"],
                            [dateDic objectForKey:@"HH"],
                            [dateDic objectForKey:@"mm"]];
                } else {
                    return [NSString stringWithFormat:LS(@"%@/%@/%@ %@:%@"),
                            [dateDic objectForKey:@"dd"],
                            [dateDic objectForKey:@"MM"],
                            [dateDic objectForKey:@"yyyy"],
                            [dateDic objectForKey:@"HH"],
                            [dateDic objectForKey:@"mm"]];
                }
            }
        }
        else
        {
            NSString *space = @" ";
            if ([self isSystemLanguageChinese])
            {
                space = @"";
            }
            return [NSString stringWithFormat:@"%@%@%@:%@", oneDayStr, space, [dateDic objectForKey:@"HH"],[dateDic objectForKey:@"mm"]];
        }
    }
}

+ (NSDictionary *)getDateDicFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSArray *dateArray = [dateString componentsSeparatedByString:@" "];
    NSArray *dayArray = [[dateArray objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *secoundArray = [[dateArray objectAtIndex:1] componentsSeparatedByString:@":"];
    NSMutableDictionary *dateDictionary = [[NSMutableDictionary alloc] init];
    [dateDictionary setObject:[dayArray objectAtIndex:0] forKey:@"yyyy"];
    [dateDictionary setObject:[dayArray objectAtIndex:1] forKey:@"MM"];
    [dateDictionary setObject:[dayArray objectAtIndex:2] forKey:@"dd"];
    [dateDictionary setObject:[secoundArray objectAtIndex:0] forKey:@"HH"];
    [dateDictionary setObject:[secoundArray objectAtIndex:1] forKey:@"mm"];
    return dateDictionary;
}

/////UI
+ (UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage*)scaleStretchableImage:(UIImage*)image withControlSize:(CGSize)controlSize
{
    CGSize imageSize = image.size;
    if (imageSize.width/controlSize.width >= 1.0 && imageSize.height/controlSize.height >= 1.0)
    {
        //图片比控件大，不拉伸
        return image;
    }
    else if (imageSize.width/controlSize.width >= 1.0 && imageSize.height/controlSize.height < 1.0)
    {
        //图片高度比控件小，上下拉伸
        UIImage* tmpImage = [image stretchableImageWithLeftCapWidth:0.0 topCapHeight:(imageSize.height/2.0 - 0.5)];
        CGSize newSize = CGSizeMake(imageSize.width, roundf(imageSize.width/controlSize.width*controlSize.height));
        tmpImage = [self scaleImage:tmpImage toSize:newSize];
        return tmpImage;
    }
    else if (imageSize.width/controlSize.width < 1.0 && imageSize.height/controlSize.height >= 1.0)
    {
        //图片宽度比控件小，左右拉伸
        UIImage* tmpImage = [image stretchableImageWithLeftCapWidth:(imageSize.width/2.0 - 0.5) topCapHeight:0.0];
        CGSize newSize = CGSizeMake(roundf(imageSize.height/controlSize.height*controlSize.width), imageSize.height);
        tmpImage = [self scaleImage:tmpImage toSize:newSize];
        return tmpImage;
    }
    else
    {
        //图片宽高都比控件小，全面拉伸
        return [image stretchableImageWithLeftCapWidth:(imageSize.width/2.0 - 0.5) topCapHeight:(imageSize.height/2.0 - 0.5)];
    }
}

+ (void) setImageView:(UIImageView *)imageView withImageName:(NSString *)imageName
{
    UIImage* image = [UIImage imageNamed:imageName];
    imageView.image = [self scaleStretchableImage:image withControlSize:imageView.frame.size];
}

+ (void) setBackgroundImageForButton:(UIButton *)button withNormalImageName:(NSString *)normalImageName andHighlightImageName:(NSString *)highlightImageName
{
    [self setBackgroundImageForButton:button withNormalImageName:normalImageName andHighlightImageName:highlightImageName andSelectedImageName:nil andDisabledImageName:nil];
}

+ (void) setBackgroundImageForButton:(UIButton *)button withNormalImageName:(NSString *)normalImageName andHighlightImageName:(NSString *)highlightImageName andSelectedImageName:(NSString *)selectedImageName andDisabledImageName:(NSString *)disabledImageName
{
    CGSize size = button.frame.size;
    if (normalImageName != nil)
    {
        UIImage* image = [UIImage imageNamed:normalImageName];
        UIImage* tmpImage = [self scaleStretchableImage:image withControlSize:size];
        [button setBackgroundImage:tmpImage forState:UIControlStateNormal];
    }
    if (highlightImageName != nil)
    {
        UIImage* image = [UIImage imageNamed:highlightImageName];
        UIImage* tmpImage = [self scaleStretchableImage:image withControlSize:size];
        [button setBackgroundImage:tmpImage forState:UIControlStateHighlighted];
    }
    if (selectedImageName != nil)
    {
        UIImage* image = [UIImage imageNamed:selectedImageName];
        UIImage* tmpImage = [self scaleStretchableImage:image withControlSize:size];
        [button setBackgroundImage:tmpImage forState:UIControlStateSelected];
    }
    if (disabledImageName != nil)
    {
        UIImage* image = [UIImage imageNamed:disabledImageName];
        UIImage* tmpImage = [self scaleStretchableImage:image withControlSize:size];
        [button setBackgroundImage:tmpImage forState:UIControlStateDisabled];
    }
}



+ (UIViewController *)viewController:(UIView *)view
{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

/*camara 功能
+ (AVCaptureDevice *)getFrontCameraDevice
{
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo])
    {
        if (device.position == AVCaptureDevicePositionFront)
        {
            return device;
        }
    }
    return nil;
}

+ (AVCaptureDevice *)getBackCameraDevice
{
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo])
    {
        if (device.position == AVCaptureDevicePositionBack)
        {
            return device;
        }
    }
    return nil;
}
*/
@end
