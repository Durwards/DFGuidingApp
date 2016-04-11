//
//  DFToast.h   这是一个基于第三方MBProgressHUD的自定义toast
//
//  Created by 何定飞 on 15/10/13.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface DFToastView : NSObject{
    MBProgressHUD *hud;
}
- (id)initWithParentView:(UIView*)parentView andText:(NSString*)text;

- (void)show;

- (void) setYOffset:(int) yOffset;

@end
