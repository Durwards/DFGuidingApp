//
//  DFTools.h
//  GuidingApp
//
//  Created by 何定飞 on 15/8/25.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DFConstant.h"
#import "DFObject.h"

@interface DFObject : NSObject
@property (weak, nonatomic) NSObject* userData;
- (id)initWithUserData:(id)userData;
@end


/*
 >>>>>>>>>>>>工具宏<<<<<<<<<<<
 */
//颜色宏
#define GRAY(c)             GRAY_ALPHA(c, 255)
#define GRAY_ALPHA(c, a)    RGBA(c, c, c, a)
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a/255.0f)]
#define RGBFromHexadecimal(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]
#define RGBFromHexadecimal_Alpha(value,value2) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:value2]

#define IRGBA(r, g, b, a)   [UIImage imageWithColor:RGBA(r, g, b, a) andSize:CGSizeMake(2.0f, 2.0f)]
#define IRGB(r, g, b)       IRGBA(r, g, b, 255)
#define IGRAY(c)            IRGB(c, c, c)
#define IGRAY_ALPHA(c, a)   IRGBA(c, c, c, a)
#define IMGFromColor(color) [UIImage imageWithColor:color andSize:CGSizeMake(2.0, 2.0)]
#define IMGFromHexadecimal(value) [UIImage imageWithColor:RGBFromHexadecimal(value) andSize:CGSizeMake(2.0, 2.0)]
#define IMGFromHexadecimal_Alpha(value,value2) [UIImage imageWithColor:RGBFromHexadecimal_Alpha(value,value2) andSize:CGSizeMake(2.0, 2.0)]


//图片宏
#define IMG(str)    [UIImage imageNamed:str]

//字符操作宏
#define FONTSIZE(A) [UIFont systemFontOfSize: A]
#define LS(str)     NSLocalizedString(str, nil)
#define KLStrCat(A, B) [NSString stringWithFormat:@"%@%@", A, B]
#define STR2URL(str) [NSURL URLWithString:str]
#define RES2URL(fileName, fileExt) [[NSBundle mainBundle] pathForResource:fileName ofType:fileExt]

#define LV(file, index) [[NSBundle mainBundle] loadNibNamed:file owner:self options:nil][index];
#define LV0(file) [[NSBundle mainBundle] loadNibNamed:file owner:self options:nil][0];

//尺寸宏
#define Screen_Frame   (CGRect) ([UIScreen mainScreen].bounds)
#define Screen_Width   (int)([UIScreen mainScreen].bounds.size.width)
#define Screen_Height  (int)([UIScreen mainScreen].bounds.size.height)

#define View_Frame(view) view.frame
#define View_X(view) view.frame.origin.x
#define View_Y(view) view.frame.origin.y
#define View_Width(view)   view.frame.size.width
#define View_Height(view)  view.frame.size.height

//进程宏
#define EXECUTE_BLOCK_IN_MAIN_DELAY_BEGIN(delay)  double delayInSeconds__________ = delay;\
dispatch_time_t popTime_____________ = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds__________ * NSEC_PER_SEC));\
dispatch_after(popTime_____________, dispatch_get_main_queue(), ^(void){                    //主线程延迟开始
#define EXECUTE_BLOCK_IN_MAIN_BEGIN         dispatch_async(dispatch_get_main_queue(), ^{    //主线程开始
#define EXECUTE_BLOCK_IN_BKGND_BEGIN        dispatch_async(dispatch_get_global_queue        (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{                                                //分线程开始
#define EXECUTE_BLOCK_END                   });                                             //线程结束


#define NSLog(format, ...) do {                                                     \
fprintf(stderr, "<%s : %d> %s\n",                                                   \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                                   \
fprintf(stderr, "-------\n");                                                       \
} while (0)

#define NSLogRect(rect) NSLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define NSLogSize(size) NSLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define NSLogPoint(point) NSLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)

/*
 >>>>>>>>>>>>>>>>规范<<<<<<<<<<<<<<<<<<
 */

#define DF_Color RGBFromHexadecimal(0x644d64)   //偏紫色
#define DF_BackgroundColor RGBFromHexadecimal(0xe0e4f7) //偏蓝色
#define DF_BackgroundColor_Alpha RGBFromHexadecimal_Alpha(0xe0e4f7,0.8)
#define DF_BackgroundIMG IMGFromHexadecimal_Alpha(0xe0e4f7,0.8)

#define DF_BORDER_WEIDTH 0.6
#define DF_BORDER_COLOR GRAY(222)  // dedede

#define DF_WARNING_COLOR_NORMAL RGBFromHexadecimal(0xfe4c5d)
#define DF_WARNING_COLOR_ENABLE RGBFromHexadecimal(0xfe7986)

#define DF_Button_Full_Normal IMGFromHexadecimal(0xA6AACE)  //填充按钮
#define DF_Button_Full_Highlighted IMGFromHexadecimal(0x8A94CE)
#define DF_Button_Full_Enable IMGFromHexadecimal(0xCCD1FD)



@interface DFTools : NSObject

+ (id)sharedInstance;

+ (void)setBtnCycle:(id) sender
        borderWidth:(float) width
        borderColor:(UIColor *)color;

///////////网络
//检测网络是否可用
+ (BOOL)checkNetworkConnection; //有提示
+ (BOOL)isNetworkConnection;    //无提示
+ (BOOL)is3GWifi;
+ (BOOL)is4GWifiOrHigher;
+ (int)checkNetworkState;       //Network_Wifi=0 ,Network_Mobile=1 ,Network_None=2

//////////系统
+ (BOOL)isIOS5;
+ (BOOL)isIOS5orLower;
+ (BOOL)isIOS5orHigher;
+ (BOOL)isIOS6;
+ (BOOL)isIOS7;
+ (BOOL)isIOS7orHigher;
+ (BOOL)isIOS8orHigher;
+ (BOOL)isIOS9orHigher;

+ (BOOL)isInch3_5;
+ (BOOL)isInch4;

+(BOOL)checkAppInstalled:(NSString *)urlSchemes;    //判断是否安装了某应用
+(BOOL)isSystemLanguageChinese;                     //是否是中文

+ (BOOL)isPureNumberWithText:(NSString *)text;     // 是否为纯数字
+ (BOOL)isPureEnglishWithText:(NSString *)text;    // 是否为存字母
+ (BOOL)isMobileNumber:(NSString *)mobileNum;       // 是否为手机号

+ (NSDictionary *)getDateDicFromDate:(NSDate *)date;            // 把时间放到字典里
+ (BOOL)isTodayWithTimeInterval:(NSTimeInterval)tmDate;         // 是否是今天
+ (NSString *)formatTimeInterval:(NSTimeInterval)timeInterval;  // a.本日的，显示“hh:mm”；b.隔一天的，显示“昨天hh:mm” 或者 “明天hh:mm”；c.本年内的，显示“MM/DD hh:mm”；d.非本年的，显示“YYYY/MM/DD hh:mm”。

//UI相关
//获取当前view所在的controller。
+ (UIViewController *)viewController:(UIView *)view;

//UIImage
+ (UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)size;
+ (void) setImageView:(UIImageView *) imageView withImageName:(NSString *) imageName;
//UIButton
+ (void) setBackgroundImageForButton:(UIButton *)button withNormalImageName:(NSString *)normalImageName andHighlightImageName:(NSString *)highlightImageName;
+ (void) setBackgroundImageForButton:(UIButton *)button withNormalImageName:(NSString *)normalImageName andHighlightImageName:(NSString *)highlightImageName andSelectedImageName:(NSString *)selectedImageName andDisabledImageName:(NSString *)disabledImageName;


//字典-对象 互转


/*camera功能
+ (AVCaptureDevice *)getFrontCameraDevice;
+ (AVCaptureDevice *)getBackCameraDevice;
*/
@end

