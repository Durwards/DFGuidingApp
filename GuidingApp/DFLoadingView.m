//
//  LoadingView.m
//  GuidingApp
//
//  Created by 何定飞 on 15/8/27.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import "DFLoadingView.h"
#import "DGActivityIndicatorView/DGActivityIndicatorView.h"

@implementation DFLoadingView{
    __weak UIView* _transparentPie;
    __weak UIImageView* _loadingAnimationView;
    __weak UIButton* _wBtnRetry;
    
    NSString *loadingText;
}
@dynamic alpha;

//加载按钮
- (UIView *)createLoadingAnimation
{
    UIView* transparentPie = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    _transparentPie = transparentPie;
    _transparentPie.layer.cornerRadius = loadingText?10:_transparentPie.frame.size.height/2;
    _transparentPie.layer.masksToBounds = YES;
    
    UIImageView *loadingAnimationView = [[UIImageView alloc]initWithFrame:CGRectMake(-2, -2,100,100)];
    _loadingAnimationView = loadingAnimationView;
    [_transparentPie addSubview:_loadingAnimationView];
    
    NSMutableArray * animationImages = [[NSMutableArray alloc]init];
    UIImage *image;
    for (int i = 1; i <= 15; i++) {
        NSString *imageName = [NSString stringWithFormat:@"loading%02d",i];
        image = IMG(imageName);
        
        [animationImages addObject:image];
    }
    [_loadingAnimationView setAnimationImages:animationImages];
    [_loadingAnimationView startAnimating];
    
    if (loadingText) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 135, 150, 15)];
        
        transparentPie.frame = CGRectMake(0, 0, 160, 160);
        loadingAnimationView.frame = CGRectMake(30, 20, 100, 100);
        
        label.textAlignment = NSTextAlignmentCenter;
        label.text = loadingText;
        label.textColor = DF_BackgroundColor;
        [_transparentPie addSubview:label];
    }
    
    if ([DFTools isIOS7orHigher])
    {
        UIView* rootView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 58.0f, 58.0f + 50.0f)];
        rootView.backgroundColor = GRAY_ALPHA(0, 0);
        [rootView addSubview:_transparentPie];
        return rootView;
    }
    return _transparentPie;
}

//重试按钮
- (UIView *)createRetryButtonWithTarget:(id)target andAction:(SEL)action
{
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 120.0f)];
    pannel.backgroundColor = GRAY_ALPHA(0, 0);
    
    UIButton* btnRetry  = [UIButton buttonWithType:UIButtonTypeCustom];
    _wBtnRetry = btnRetry;
    btnRetry.frame = CGRectMake(31.0f, 31.0f, 58.0f, 58.0f);
    [btnRetry addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [pannel addSubview:_wBtnRetry];
    [btnRetry setBackgroundImage:IMG(@"btnRetry_n") forState:UIControlStateNormal];
    [btnRetry setBackgroundImage:IMG(@"btnRetry_p") forState:UIControlStateHighlighted];
    btnRetry.backgroundColor = GRAY_ALPHA(0, 0);
    
    UILabel* lblRetry = [[UILabel alloc]init];
    lblRetry.text = LS(@"加载失败，点击重试");
    lblRetry.textAlignment = NSTextAlignmentCenter;
    lblRetry.backgroundColor = GRAY_ALPHA(0, 0);
    lblRetry.font = FONTSIZE(13.0f);
    lblRetry.textColor = GRAY(182);
    CGSize textSize = [lblRetry.text sizeWithAttributes:@{NSFontAttributeName:lblRetry.font}];
    textSize.height += 2.0f;
    textSize.width += 2.0f;
    lblRetry.frame = CGRectMake(60.0f - textSize.width / 2.0f, 120.0f - textSize.height, textSize.width, textSize.height);
    
    [pannel addSubview:lblRetry];
    
    if ([DFTools isIOS7orHigher])
    {
        UIView* rootView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 120.0f + 50.0f)];
        rootView.backgroundColor = GRAY_ALPHA(0, 0);
        [rootView addSubview:pannel];
        return rootView;
    }
    return pannel;
}



-(id)initWithParentView:(UIView *)parentView andText:(NSString *)text{
    self = [super init];
    if (self)
    {
        
        // Initialization code
        loadingText = text;
        hud = [[MBProgressHUD alloc] initWithView:parentView];
        hud.opacity = 0.0f;
        hud.xOffset = -50;
        hud.removeFromSuperViewOnHide = YES;
        hud.mode = MBProgressHUDModeCustomView;
        
        hud.customView = [self createLoadingAnimation];
        [parentView addSubview:hud];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeAnimation:) name:DFApplicationBecomeActive object:nil];
    }
    return self;

}

- (id)initWithSuperView:(UIView*)superView_ withTarget:(id)target andAction:(SEL)action//重试按钮用的
{
    self = [super init];
    if (self)
    {
        // Initialization code
        hud = [[MBProgressHUD alloc] initWithView:superView_];
        hud.opacity = 0.0f;
        hud.removeFromSuperViewOnHide = YES;
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [self createRetryButtonWithTarget:target andAction:action];
        [superView_ addSubview:hud];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeAnimation:) name:DFApplicationBecomeActive object:nil];
    }
    return self;
}

- (void)show
{
    [hud show:YES];
}

- (void)hide
{
    if (animationView)
    {
        [animationView removeFromSuperview];
        return;
    }
    [hud hide:YES];
}

- (void)setText:(NSString *)text
{
    hud.labelText = text;
}

- (void)setAlpha:(CGFloat)alpha
{
    _transparentPie.backgroundColor = GRAY_ALPHA(0, (255.0f * alpha));
}



- (void)resumeAnimation:(NSNotification*) notification
{
    [_loadingAnimationView stopAnimating];
    [_loadingAnimationView startAnimating];
}

- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object
{
    [hud showWhileExecuting:method onTarget:target withObject:object animated:YES];
}

@end
