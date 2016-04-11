//
//  HomeNavCell.m
//  GuidingApp
//
//  Created by 何定飞 on 15/12/8.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "HomeNavCell.h"
#import "UIImageView+WebCache.h"

@implementation HomeNavCell {
    __weak IBOutlet UIView *buttonView;
    __weak IBOutlet UIImageView *headImage;
    __weak IBOutlet UILabel *nickNamelbl;
    __weak IBOutlet UILabel *detaillbl;
}

- (void)awakeFromNib {
    // Initialization code
    headImage.layer.cornerRadius = headImage.frame.size.height/2 ;
    headImage.layer.borderWidth = 1;
    headImage.layer.borderColor = DF_BORDER_COLOR.CGColor;
    headImage.layer.masksToBounds = YES ;
    
}

- (void)setContentWithImageText:(UIImage *)imageText withTitle:(NSString *)title withDetail:(NSString *)detail {
    nickNamelbl.text = title;
    detaillbl.text = detail;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self showBtns];
    } else {
        [self hideBtns];
    }
}

- (void)showBtns {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = buttonView.frame;
        rect.origin.x = 0;
//        rect.origin.y = 0;
        buttonView.frame = rect;
        buttonView.alpha = 0.8;
    }];
}

- (void)hideBtns {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = buttonView.frame;
        rect.origin.x = 180;
//        rect.origin.y = -80;
        buttonView.frame = rect;
        buttonView.alpha = 0;
    }];
}
- (IBAction)infoBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(spotFriInfoBtnClick:)]) {
        [self.delegate spotFriInfoBtnClick:sender];
    }
}
- (IBAction)naviBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(spotFriNaviBtnClick:)]) {
        [self.delegate spotFriNaviBtnClick:sender];
    }
}

@end
