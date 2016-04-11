//
//  DFBaseViewController.h
//  GuidingApp
//
//  Created by 何定飞 on 15/10/13.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFNoticeView.h"
#import "DFNetworkManager.h"

@interface DFBaseViewController : UIViewController <DFNoticeViewDelegate>{
    AppDelegate * appDelegate;
    __weak DFNoticeView* _noticeView;
}

@property (nonatomic, assign) int nvBarButtonType;

///////////Navigation
//NavigationBar
- (void)setNavigationBarAlpha:(float)alpha withTextColor:(UIColor *)color;
- (void)setNavigationBarAlpha:(float)alpha;
//LeftBarIten
- (void)setLeftBarItem:(SEL)selector image:(NSString*)strImagePathNormal highlightedImage:(NSString*)strImagePathHighlighted;
- (void)setLeftBarItem:(SEL)selector image:(NSString*)strImagePathNormal selectedImage:(NSString*)strImagePathSelected;


//RightBarItem
- (void)setRightBarItem:(NSString*)text WithColor:(UIColor *)color WithAction:(SEL)selector;
- (void)setRightBarItem:(SEL)selector image:(NSString*)strImagePathNormal highlightedImage:(NSString*)strImagePathHighlighted;
- (void)setRightBarItem:(SEL)selector image:(NSString*)strImagePathNormal selectedImage:(NSString*)strImagePathSelected;
- (void)setRightBarItemEnable:(BOOL)bEnable;
- (void)hideRightBarItem;

//loadingView、retryView;
- (void)showLoadingViewWithAlpha:(CGFloat)alpha; /*0 - 1, 0表示完全透明，大多数情况下使用0.8*/
- (void)showLoadingViewWithAlpha:(CGFloat)alpha withText:(NSString *)text;
- (void)hideLoadingView;
- (void)showRetryView;
- (void)onRetryButtonTaped:(id)sender;

//toastView;
- (void)showToastView:(NSString *)text;
- (void)showToastViewOnRootView:(NSString *)text;

//login && register
- (BOOL)isUserLogined;

- (void)showLoginView;

- (void)showViewController:(DFBaseViewController*)viewController animated:(BOOL)animate;


// notice view
- (void)showNoticeViewPlainText:(NSString *)title
                    withContent:(NSString*)content
               withConfirmTitle:(NSString *)confirmTitle
                withCancelTitle:(NSString *)cancelTitle
                 withNoticeMode:(int)mode
                  withIsWarning:(BOOL)isWarning;

- (void)showNoticeViewCustomView:(NSString*)title
                 withContentView:(UIView*)contentView
                withConfirmTitle:(NSString*)cancelTitle
                 withCancelTitle:(NSString*)confirmTitle
                  withNoticeMode:(DFNoticeMode)mode
                   withIsWarning:(BOOL)isWarning;
- (void)hideNoticeView;
- (void)clickedConfirmButton;
- (void)clickedCancelButton;

@property (assign, nonatomic) BOOL maskOn;//将本变量置为True，就可以创建一个充满全屏的、完全透明的按钮。这个按钮的点击响应函数是 onBtnMask:，将本变量置为FALSE，这个完全透明的按钮即从父view移除
@property (strong, nonatomic) UIColor* maskColor;//maskOn为TRUE状态下，设置全屏按钮的背景颜色。

@end
