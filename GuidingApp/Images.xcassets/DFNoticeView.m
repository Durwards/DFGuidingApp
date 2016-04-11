//
//  DFNoticeView.m
//  GuidingApp
//
//  Created by 何定飞 on 15/11/2.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "DFNoticeView.h"

@implementation DFNoticeView

@synthesize noticeView = _noticeView;
@synthesize titleLabel = _titleLabel;
@synthesize cancelButton = _cancelButton;
@synthesize confirmButton = _confirmButton;
@synthesize bkgImageView = _bkgImageView;
@synthesize contentView;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void) setSuperView:(UIView *)view
                title:(NSString *)title
          contentView:(UIView *)_contentView
    cancelButtonTitle:(NSString *)cancelButtonTitle
   confirmButtonTitle:(NSString *)confirmButtonTitle
           noticeMode:(DFNoticeMode)noticeMode
             delegate:(id<DFNoticeViewDelegate>)delegate
{
    if (!view || !_contentView)
        return;
    
    superView = view;
    self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    
    int yPos = 0;
    if (title != nil)
    {
        yPos = TITLE_HEIGHT;
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _noticeView.frame.size.width, yPos)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = GRAY(71);
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.backgroundColor = RGB(241, 241, 243);
        [self.noticeView addSubview:titleLabel];
    }
    
    self.contentView = _contentView;
    self.contentView.frame = CGRectMake(0,yPos, contentView.frame.size.width, contentView.frame.size.height);
    [self.noticeView addSubview:self.contentView];
    
    CGRect frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height + BOTTOM_HEIGHT + yPos);
    CGPoint center = self.noticeView.center;
    if(view.frame.size.width > 320)
        center = view.center;
    self.noticeView.bounds = frame;
    self.noticeView.center = center;
    self.noticeView.layer.masksToBounds = YES;
    self.noticeView.layer.cornerRadius = 3;
    
    if (!cancelButtonTitle && !confirmButtonTitle)
    {
        _bottomView.hidden = YES;
        return;
    }
    else if (cancelButtonTitle && !confirmButtonTitle)
    {
        _line2View.hidden = YES;
        self.confirmButton.hidden = YES;
        self.cancelButton.hidden = NO;
        
        CGRect frame = self.cancelButton.frame;
        frame.origin.x = 0;
        frame.size.width = _noticeView.frame.size.width;
        self.cancelButton.frame = frame;
    }
    else if (!cancelButtonTitle && confirmButtonTitle)
    {
        _line2View.hidden = YES;
        self.confirmButton.hidden = NO;
        self.cancelButton.hidden = YES;
        
        CGRect frame = self.confirmButton.frame;
        frame.size.width = _noticeView.frame.size.width;
        frame.origin.x = 0;
        self.confirmButton.frame = frame;
    }
    else
    {
        _line2View.hidden = NO;
        self.confirmButton.hidden = NO;
        self.cancelButton.hidden = NO;
    }
    
    _bottomView.hidden = NO;
    frame = _bottomView.frame;
    frame.origin.y = CGRectGetMaxY(self.contentView.frame);
    _bottomView.frame = frame;
    
    frame = _line1View.frame;
    frame.size.height = DF_BORDER_WEIDTH;
    _line1View.frame = frame;
    _line1View.backgroundColor = DF_BORDER_COLOR;
    
    frame = _line2View.frame;
    frame.size.width = DF_BORDER_WEIDTH;
    _line2View.frame = frame;
    _line2View.backgroundColor = DF_BORDER_COLOR;
    
    [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:RGBFromHexadecimal(0x818181) forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:IGRAY(222) forState:UIControlStateHighlighted];
    
    if (self.isWarning)
    {
        [self.confirmButton setTitleColor:DF_WARNING_COLOR_NORMAL forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:DF_WARNING_COLOR_NORMAL forState:UIControlStateHighlighted];
        [self.confirmButton setTitleColor:DF_WARNING_COLOR_ENABLE forState:UIControlStateDisabled];
    }
    else
    {
        [self.confirmButton setTitleColor:DF_Color forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:DF_Color forState:UIControlStateHighlighted];
        [self.confirmButton setTitleColor:RGBFromHexadecimal(0xa3e6ea) forState:UIControlStateDisabled];
    }
    
    [self.confirmButton setTitle:confirmButtonTitle forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:IGRAY(222) forState:UIControlStateHighlighted];
    
    self.noticeMode = noticeMode;
    self.delegate = delegate;
    
    
}




- (void)showPlainTextNoticeView:(UIView*)parentView
                          title:(NSString *)title
                        content:(NSString *)content
              cancelButtonTitle:(NSString *)cancelButtonTitle
             confirmButtonTitle:(NSString *)confirmButtonTitle
                     noticeMode:(DFNoticeMode)noticeMode
                       delegate:(id<DFNoticeViewDelegate>)delegate
{
    int width = _noticeView.frame.size.width;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1000)];
    
    int yPos = 10;
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = GRAY(129);
    label.font = [UIFont systemFontOfSize:16];
    label.text = content;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = PLAINTEXTLABELTAG;
    
    CGSize size = [content sizeWithFont:label.font constrainedToSize:CGSizeMake(width - 2*MARGIN_SPACE, 1000)];
    label.frame = CGRectMake(MARGIN_SPACE, yPos, width - 2*MARGIN_SPACE, size.height + 30);
    [view addSubview:label];
    
    view.frame = CGRectMake(0, 0, width, size.height + yPos + BOTTOM_HEIGHT);
    
    [self setSuperView:parentView
                 title:title
           contentView:view
     cancelButtonTitle:cancelButtonTitle
    confirmButtonTitle:confirmButtonTitle
            noticeMode:noticeMode
              delegate:delegate];
    
    [self showNoticeView];
}

- (IBAction)onCancelButtonClicked:(id)sender {
    if (self.buttonClick)
    {
        UIButton *btn = (UIButton *)sender;
        int tag = (int)btn.tag;
        _buttonClick(tag);
    }
    else
    {
        if (self.delegate)
        {
            if ([self.delegate respondsToSelector:@selector(clickedCancelButton)])
                [self.delegate performSelector:@selector(clickedCancelButton)];
            else if ([self.delegate respondsToSelector:@selector(noticeView:clickedCancelBtn:)])
                [self.delegate performSelector:@selector(noticeView:clickedCancelBtn:) withObject:self withObject:sender];
        }
    }

}

- (IBAction)onConfirmButtonClicked:(id)sender {
    if (self.buttonClick)
    {
        UIButton *btn = (UIButton *)sender;
        int tag = (int)btn.tag;
        _buttonClick(tag);
    }
    else
    {
        if (self.userData)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(clickedConfirmButtonWithUserData:view:)])
            {
                [self.delegate performSelector:@selector(clickedConfirmButtonWithUserData:view:) withObject:self.userData withObject:self];
            }
        }
        else
        {
            if (self.delegate)
            {
                if ([self.delegate respondsToSelector:@selector(clickedConfirmButton)])
                {
                    [self.delegate performSelector:@selector(clickedConfirmButton)];
                }
                else if ([self.delegate respondsToSelector:@selector(noticeView:clickedConfirmBtn:)])
                {
                    [self.delegate performSelector:@selector(noticeView:clickedConfirmBtn:) withObject:self withObject:sender];
                }
            }
        }
    }
}

- (void) showNoticeView
{
    [superView addSubview:self];
}

- (void) dismissNoticeView
{
    [self removeFromSuperview];
}

@end
