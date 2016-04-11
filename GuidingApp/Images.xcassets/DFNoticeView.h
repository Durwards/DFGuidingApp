//
//  DFNoticeView.h
//  GuidingApp
//
//  Created by 何定飞 on 15/11/2.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TITLE_HEIGHT 38
#define BOTTOM_HEIGHT 38
#define MARGIN_SPACE 10
#define PLAINTEXTLABELTAG   456789

typedef enum
{
    DFNoticeMode_Mode1 = 0,
    DFNoticeMode_Mode2 = 1,
    DFNoticeMode_Mode3 = 2,
}DFNoticeMode;

@protocol DFNoticeViewDelegate <NSObject>
@optional
- (void) clickedCancelButton;
- (void) clickedConfirmButton;
- (void) clickedConfirmButtonWithUserData:(id)userData view:(id)noticeView;
- (BOOL) noticeView:(DFNoticeMode *)noticeView clickedCancelBtn:(id)sender;
- (BOOL) noticeView:(DFNoticeMode *)noticeView clickedConfirmBtn:(id)sender;
@end


@interface DFNoticeView : UIView<DFNoticeViewDelegate>
{
    __weak UIView * superView;
    
    IBOutlet UIView *_bottomView;
    IBOutlet UIView *_line1View;
    IBOutlet UIView *_line2View;
    IBOutlet UIButton *_cancelButton;
    IBOutlet UIButton *_confirmButton;
}

@property (nonatomic, assign) BOOL isWarning;
@property (nonatomic, assign) BOOL clickBackgroundToCancel;
@property (nonatomic, strong) UIView * noticeView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) UIButton * confirmButton;
@property (nonatomic, strong) UIImageView * bkgImageView;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, assign) DFNoticeMode noticeMode;
@property (nonatomic, weak) id<DFNoticeViewDelegate> delegate;
@property (nonatomic, strong) id userData;

@property(nonatomic,copy) void (^buttonClick)(int tag);  // 0:取消  1:确定

- (void) setSuperView:(UIView *)view
                title:(NSString *)title
          contentView:(UIView *)contentView
    cancelButtonTitle:(NSString *)cancelButtonTitle
   confirmButtonTitle:(NSString *)confirmButtonTitle
           noticeMode:(DFNoticeMode)noticeMode
             delegate:(id<DFNoticeViewDelegate>)delegate;

- (void)showPlainTextNoticeView:(UIView*)parentView
                          title:(NSString *)title
                        content:(NSString *)content
              cancelButtonTitle:(NSString *)cancelButtonTitle
             confirmButtonTitle:(NSString *)confirmButtonTitle
                     noticeMode:(DFNoticeMode)noticeMode
                       delegate:(id<DFNoticeViewDelegate>)delegate;


- (void) showNoticeView;
- (void) dismissNoticeView;

@end
