//
//  DFBaseViewController.m
//  GuidingApp
//
//  Created by 何定飞 on 15/10/13.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "DFBaseViewController.h"
#import "DFToastView.h"
#import "DFLoadingView.h"
#import "DFTools.h"

@interface DFBaseViewController ()

@end

@implementation DFBaseViewController
{
    DFLoadingView* _loadingView;
    UIButton* _btnMask;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        appDelegate = [UIApplication sharedApplication].delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setNavigationBar];
    self.view.backgroundColor = GRAY(247);
}

- (void)viewWillAppear:(BOOL)animated {
    [self setNavigationBar];
    [super viewWillAppear:animated];
    appDelegate.navController = self.navigationController;
    if ([DFTools isIOS7orHigher])
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault  animated:NO];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - NavigationBar
//NavigationBar
- (void)setNavigationBar {
    UINavigationBar* navBar = self.navigationController.navigationBar;
    navBar.tintColor = DF_Color;
    [navBar setBackgroundImage:DF_BackgroundIMG forBarMetrics:UIBarMetricsDefault];   //纯色背景
//    [navBar setBackgroundImage:IMG(@"home_bg") forBarMetrics:UIBarMetricsDefault];        //图片背景
    
    //iOS7下去除NavigationBar下面的阴影
    if ([DFTools isIOS7orHigher])
    {
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(0, 0);
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:DF_Color, NSShadowAttributeName:shadow, NSFontAttributeName:FONTSIZE(20)}];
        navBar.shadowImage = [[UIImage alloc]init];//去掉navbar上的黑线
    }
        
    //默认设置为左键返回
    if (self.nvBarButtonType == LeftNavigationItemBack){
        [self setLeftBarItem:@selector(onLeftBackBtnTaped:) image:@"navigation_back" highlightedImage:@"navigation_back"];
    }
}

- (void)setNavigationBarAlpha:(float)alpha withTextColor:(UIColor *)color{
    UINavigationBar* navBar = self.navigationController.navigationBar;
    navBar.tintColor = color;
    [navBar setBackgroundImage:IMGFromHexadecimal_Alpha(0x000000,alpha) forBarMetrics:UIBarMetricsDefault];   //透明背景
    
    //iOS7下去除NavigationBar下面的阴影
    if ([DFTools isIOS7orHigher])
    {
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(0, 0);
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color, NSShadowAttributeName:shadow, NSFontAttributeName:FONTSIZE(20)}];
        navBar.shadowImage = [[UIImage alloc]init];//去掉navbar上的黑线
    }
    
    //默认设置为左键返回
    if (self.nvBarButtonType == LeftNavigationItemBack){
        [self setLeftBarItem:@selector(onLeftBackBtnTaped:) image:@"navigation_back" highlightedImage:@"navigation_back"];
    }
    
}

- (void)setNavigationBarAlpha:(float)alpha{
    UINavigationBar* navBar = self.navigationController.navigationBar;
    navBar.tintColor = DF_Color;
    [navBar setBackgroundImage:IMGFromHexadecimal_Alpha(0xe0e4f7,alpha) forBarMetrics:UIBarMetricsDefault];   //透明背景
    
    //iOS7下去除NavigationBar下面的阴影
    if ([DFTools isIOS7orHigher])
    {
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(0, 0);
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:DF_Color, NSShadowAttributeName:shadow, NSFontAttributeName:FONTSIZE(20)}];
        navBar.shadowImage = [[UIImage alloc]init];//去掉navbar上的黑线
    }
    
    //默认设置为左键返回
    if (self.nvBarButtonType == LeftNavigationItemBack){
        [self setLeftBarItem:@selector(onLeftBackBtnTaped:) image:@"navigation_back" highlightedImage:@"navigation_back"];
    }
    
}

//LeftBarItem
- (void)setLeftBarItem:(SEL)selector image:(NSString*)strImagePathNormal highlightedImage:(NSString*)strImagePathHighlighted {
    //设置leftBarButtonItem
    UIButton* leftBarBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
    [leftBarBtn setImage:[UIImage imageNamed:strImagePathNormal] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:strImagePathHighlighted] forState:UIControlStateHighlighted];
    [leftBarBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    if ([DFTools isIOS7orHigher])
        leftBarBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0f, -5, 0, 5);
    else
        leftBarBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 5, 0, -5);
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = buttonItem;
}

-(void)setLeftBarItem:(SEL)selector image:(NSString *)strImagePathNormal selectedImage:(NSString *)strImagePathSelected {
    UIButton* leftBarBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
    [leftBarBtn setImage:[UIImage imageNamed:strImagePathNormal] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:strImagePathSelected] forState:UIControlStateSelected];
    [leftBarBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    if ([DFTools isIOS7orHigher])
        leftBarBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0f, -5, 0, 5);
    else
        leftBarBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0f, 5, 0, -5);
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = buttonItem;

}


//RightBarItem
- (void)setRightBarItem:(NSString*)text WithColor:(UIColor *)color WithAction:(SEL)selector {
    if ([DFTools isIOS7orHigher]) {
        UIBarButtonItem * rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:text
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:selector];
        rightBarBtn.tintColor = color;
        [rightBarBtn setTitlePositionAdjustment:UIOffsetMake(-4.0f, 0) forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.rightBarButtonItem = rightBarBtn;
    }
    else {
        UIButton* rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        if (size.width < 40.0f)
            size.width = 40.0f;
        else if (size.width > 60.0f)
            size.width = 60.0f;
        rightBtn.frame = CGRectMake(0.0f, 0.0f, size.width + 20.0f, 30.0f);
        rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, -5.0f);
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [rightBtn setTitleColor:color forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [rightBtn setTitle:text forState:UIControlStateNormal];
        [rightBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    }
}

- (void)setRightBarItem:(SEL)selector image:(NSString*)strImagePathNormal highlightedImage:(NSString*)strImagePathHighlighted{
    //设置rightBarButtonItem
    UIButton* rightBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
    if (strImagePathNormal)
    {
        [rightBarButton setImage:[UIImage imageNamed:strImagePathNormal] forState:UIControlStateNormal];
    }
    if (strImagePathHighlighted)
    {
        [rightBarButton setImage:[UIImage imageNamed:strImagePathHighlighted] forState:UIControlStateHighlighted];
    }
    if (selector)
    {
        [rightBarButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([DFTools isIOS7orHigher])
    {
        //从sdk7开始，rightBarButtonItem按钮比以前的版本左移了20个像素，而且sdk不提供设置rightBarButtonItem位置的方法，所以只能将贴图右偏
        rightBarButton.imageEdgeInsets = UIEdgeInsetsMake(0,5,0,-5);
    }
    else
    {
        rightBarButton.imageEdgeInsets = UIEdgeInsetsMake(0,-5,0,5);
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
}

- (void)setRightBarItem:(SEL)selector image:(NSString*)strImagePathNormal selectedImage:(NSString*)strImagePathSelected {
    //设置rightBarButtonItem
    UIButton* rightBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
    if (strImagePathNormal)
    {
        [rightBarButton setImage:[UIImage imageNamed:strImagePathNormal] forState:UIControlStateNormal];
    }
    if (strImagePathSelected)
    {
        [rightBarButton setImage:[UIImage imageNamed:strImagePathSelected] forState:UIControlStateSelected];
    }
    if (selector)
    {
        [rightBarButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([DFTools isIOS7orHigher])
    {
        //从sdk7开始，rightBarButtonItem按钮比以前的版本左移了20个像素，而且sdk不提供设置rightBarButtonItem位置的方法，所以只能将贴图右偏
        rightBarButton.imageEdgeInsets = UIEdgeInsetsMake(0,5,0,-5);
    }
    else
    {
        rightBarButton.imageEdgeInsets = UIEdgeInsetsMake(0,-5,0,5);
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];

}


- (void)hideRightBarItem {
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)setRightBarItemEnable:(BOOL)bEnable {
    self.navigationItem.rightBarButtonItem.enabled = bEnable;
    UIButton* btn = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    if (btn != nil)
        btn.enabled = bEnable;
}

#pragma mark - LoadingView and ErrorView
- (void)showLoadingViewWithAlpha:(CGFloat)alpha {   /*0 - 1, 0表示完全透明*/
    [self hideLoadingView];
    
    _loadingView = [[DFLoadingView alloc] initWithParentView:self.view andText:nil];
    _loadingView.alpha = alpha;
    [_loadingView show];
}

- (void)showLoadingViewWithAlpha:(CGFloat)alpha withText:(NSString *)text {
    [self hideLoadingView];
    _loadingView = [[DFLoadingView alloc]initWithParentView:self.view andText:text];
    _loadingView.alpha = alpha;
    [_loadingView show];
}

- (void)hideLoadingView {
    if (_loadingView != nil) {
        [_loadingView hide];
        _loadingView = nil;
    }
}

- (void)showRetryView {
    [self hideLoadingView];
    
    _loadingView = [[DFLoadingView alloc] initWithSuperView:self.view withTarget:self andAction:@selector(onRetryButtonTaped:)];
    [_loadingView show];
}

- (void)onRetryButtonTaped:(id)sender {
    [self hideLoadingView];
}

#pragma mark - ToastView
- (void)showToastView:(NSString *)text {
    DFToastView* toastView = [[DFToastView alloc] initWithParentView:self.view andText:text];
    [toastView show];
}

- (void)showToastViewOnRootView:(NSString *)text {
    DFToastView * toastView = [[DFToastView alloc] initWithParentView:appDelegate.window andText:text];
    [toastView show];
}



#pragma mark -BtnClickEvent
- (void)onLeftBackBtnTaped:(id)sender {
    //这里用来[[NSNotificationCenter defaultCenter] removeObserver:self name:@"..." object:nil];等
    /** code **/
    self.view.userInteractionEnabled = NO;  //关闭该视图的响应键盘等事件
    EXECUTE_BLOCK_IN_MAIN_DELAY_BEGIN(0.5)
    [self dismissViewControllerAnimated:(sender != nil ? YES : NO) completion:nil];
    EXECUTE_BLOCK_END
    
}


- (void)tokenChanged {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"在其他地方登陆"
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
    alertView.tag = -1;
    [alertView show];
}



#pragma mark -login && register
- (BOOL)isUserLogined {
    if (![appDelegate isUserLogined])
    {
        [appDelegate showLoginView];
        return NO;
    }
    else
        return YES;
}

-(void)showLoginView {
    [appDelegate showLoginView];
}


-(void)showViewController:(DFBaseViewController *)viewController animated:(BOOL)animate {
    self.navigationController.navigationBarHidden = NO;
    [viewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:viewController animated:animate];
}


- (void)showNoticeViewPlainText:(NSString *)title
                    withContent:(NSString*)content
               withConfirmTitle:(NSString *)confirmTitle
                withCancelTitle:(NSString *)cancelTitle
                 withNoticeMode:(int)mode
                  withIsWarning:(BOOL)isWarning
{
    [self hideNoticeView];
    
    _noticeView = LV0(@"DFNoticeView");
    [_noticeView showPlainTextNoticeView:self.view
                                   title:title
                                 content:content
                       cancelButtonTitle:cancelTitle
                      confirmButtonTitle:confirmTitle
                              noticeMode:mode
                                delegate:self];
}

- (void)showNoticeViewCustomView:(NSString*)title
                 withContentView:(UIView*)contentView
                withConfirmTitle:(NSString*)confirmTitle
                 withCancelTitle:(NSString*)cancelTitle
                  withNoticeMode:(DFNoticeMode)mode
                   withIsWarning:(BOOL)isWarning
{
    [self hideNoticeView];
    
    _noticeView = LV0(@"DFNoticeView");
    _noticeView.isWarning = isWarning;
    [_noticeView setSuperView:self.view
                        title:title
                  contentView:contentView
            cancelButtonTitle:cancelTitle
           confirmButtonTitle:confirmTitle
                   noticeMode:mode
                     delegate:self];
    [_noticeView showNoticeView];
    
}
- (void)clickedConfirmButton
{
    [self hideNoticeView];
}

- (void)clickedCancelButton
{
    [self hideNoticeView];
}

- (void)hideNoticeView
{
    if (_noticeView)
    {
        [_noticeView dismissNoticeView];
        _noticeView = nil;
    }
}

#pragma mark - mask button
- (UIColor*)maskColor
{
    if (self.maskOn)
    {
        return _btnMask.backgroundColor;
    }
    else
    {
        return nil;
    }
}

- (void)createMask
{
    if (_btnMask)
        return;
    
    _btnMask = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnMask addTarget:self action:@selector(onBtnMask:) forControlEvents:UIControlEventTouchUpInside];
    _btnMask.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)setMaskColor:(UIColor *)maskColor
{
    [self createMask];
    
    if (self.maskOn)
    {
        _btnMask.backgroundColor = maskColor;
    }
}

- (void)setMaskOn:(BOOL)maskOn
{
    [self createMask];
    
    if (self.maskOn == maskOn)
        return;
    
    if (maskOn)
    {
        [self.view addSubview:_btnMask];
    }
    else
    {
        [_btnMask removeFromSuperview];
    }
}

- (BOOL)maskOn
{
    [self createMask];
    
    if (_btnMask.superview)
    {
        return YES;
    }
    return NO;
}

- (void)onBtnMask:(id)sender
{
    self.maskOn = NO;
}



@end
