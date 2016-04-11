//
//  LoadingView.h
//  GuidingApp
//
//  Created by 何定飞 on 15/8/27.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
/*****基于MBProgressHUD 的二次封装loadingView***/
@interface DFLoadingView : NSObject{
    MBProgressHUD *hud;
    UIView *animationView;
}
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailsLabel;
@property (nonatomic, strong) UIView *detailBgView;
@property (nonatomic, assign) CGFloat alpha;

- (id)initWithParentView:(UIView*)parentView andText:(NSString*)text;                   //加载按钮
- (id)initWithSuperView:(UIView*)superView_ withTarget:(id)target andAction:(SEL)action;//重试按钮

- (void)show;
- (void)hide;
- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object;//做一些延时操作的时候

- (void)setText:(NSString*)text;




@end
