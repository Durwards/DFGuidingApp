//
//  DFToast.m   这是一个基于第三方MBProgressHUD的自定义toast
//
//  Created by 何定飞 on 15/10/13.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "DFToastView.h"

@implementation DFToastView
- (id)initWithParentView:(UIView*)parentView andText:(NSString*)text
{
    self = [super init];
    if (self) {
        // Initialization code
        hud = [[MBProgressHUD alloc] initWithView:parentView];
        hud.detailsLabelText = text;
        hud.detailsLabelFont = [UIFont systemFontOfSize:16];
        hud.mode = MBProgressHUDModeText;
        hud.yOffset = 140;
        hud.removeFromSuperViewOnHide = YES;
        hud.tag = 99999;
        hud.alpha = 0.6;
        [parentView addSubview:hud];
    }
    return self;
}

- (void)show
{
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}

- (void) setYOffset:(int) yOffset
{
    hud.yOffset = yOffset;
}
@end
