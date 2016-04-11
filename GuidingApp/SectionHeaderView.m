//
//  SectionHeaderView.m
//  GuidingApp
//
//  Created by 何定飞 on 15/11/12.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView {

    __weak IBOutlet UIView *dividerLine1;
    __weak IBOutlet UIView *dividerLine2;
}

-(void)awakeFromNib {
    self.backgroundColor = GRAY(240);
    dividerLine1.backgroundColor = DF_BORDER_COLOR;
    dividerLine2.backgroundColor = DF_BORDER_COLOR;
    
}
- (IBAction)onMoreBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(moreBtnClick:)])
    {
        [self.delegate moreBtnClick:sender];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
