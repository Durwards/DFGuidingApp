//
//  CommendViewTableViewCell.m
//  GuidingApp
//
//  Created by 何定飞 on 15/11/12.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "CommendViewTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface CommendViewTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImage1;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage2;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage3;
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *leftIntroduce;
@property (weak, nonatomic) IBOutlet UILabel *leftLikeNum;

@property (weak, nonatomic) IBOutlet UIImageView *rightImage1;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage2;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage3;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightIntroduce;
@property (weak, nonatomic) IBOutlet UILabel *rightLikeNum;

@end

@implementation CommendViewTableViewCell{
    
}

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = GRAY(240);

    
}

- (void)setLeftContent:(PlaceBasic *)leftInfo withRightContent:(PlaceBasic *)rightInfo {
    [_leftImage1 sd_setImageWithURL:[NSURL URLWithString:leftInfo.placeImage] placeholderImage:IMG(@"unloading")];
    [_leftImage2 sd_setImageWithURL:[NSURL URLWithString:leftInfo.place_Image_128_1] placeholderImage:IMG(@"unloading")];
    [_leftImage3 sd_setImageWithURL:[NSURL URLWithString:leftInfo.place_Image_128_2] placeholderImage:IMG(@"unloading")];
    _leftTitle.text = leftInfo.placeName;
    _leftIntroduce.text = leftInfo.placeIntroduction;
    _leftLikeNum.text = [NSString stringWithFormat:@"%d", leftInfo.placeLikes];
    
    [_rightImage1 sd_setImageWithURL:[NSURL URLWithString:rightInfo.placeImage] placeholderImage:IMG(@"unloading")];
    [_rightImage2 sd_setImageWithURL:[NSURL URLWithString:rightInfo.place_Image_128_1] placeholderImage:IMG(@"unloading")];
    [_rightImage3 sd_setImageWithURL:[NSURL URLWithString:rightInfo.place_Image_128_2] placeholderImage:IMG(@"unloading")];

    _rightTitle.text = rightInfo.placeName;
    _rightIntroduce.text = rightInfo.placeIntroduction;
    _rightLikeNum.text = [NSString stringWithFormat:@"%d", rightInfo.placeLikes];
    
}

- (IBAction)onBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(placeCellClick:)]) {
        [self.delegate placeCellClick:sender];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
