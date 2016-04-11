//
//  HomeSpotCell.m
//  GuidingApp
//
//  Created by 何定飞 on 15/12/10.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "HomeSpotCell.h"

@implementation HomeSpotCell

- (void)awakeFromNib {
    // Initialization code
    self.spotBtn.layer.cornerRadius = self.spotBtn.frame.size.height/2;
    self.spotBtn.layer.masksToBounds = YES;
    [self.spotBtn setBackgroundColor:DF_BackgroundColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self.spotBtn setTitleColor:selected?DF_Color:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.spotBtn setTitleColor:selected?[UIColor whiteColor]:DF_Color forState:UIControlStateHighlighted];
    [self.spotBtn setBackgroundColor:selected?[UIColor whiteColor]:DF_BackgroundColor ];
    
    // Configure the view for the selected state
}
- (IBAction)onBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(spotNavBtnClick:)]) {
        [self.delegate spotNavBtnClick:sender];
    }

}

@end
