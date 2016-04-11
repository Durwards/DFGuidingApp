//
//  CollectionTableViewCell.m
//  GuidingApp
//
//  Created by 何定飞 on 15/12/12.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "CollectionTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CollectionTableViewCell
{
    __weak IBOutlet UIImageView *imageView1;
    __weak IBOutlet UIImageView *imageView2;
    __weak IBOutlet UIImageView *imageView3;
    
    __weak IBOutlet UILabel *nameLbl;
    __weak IBOutlet UILabel *detailLbl;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setContentInfo:(PlaceBasic *)info {
    [imageView1 sd_setImageWithURL:[NSURL URLWithString:info.placeImage] placeholderImage:IMG(@"unloading")];
    [imageView2 sd_setImageWithURL:[NSURL URLWithString:info.place_Image_128_1] placeholderImage:IMG(@"unloading")];
    [imageView3 sd_setImageWithURL:[NSURL URLWithString:info.place_Image_128_2] placeholderImage:IMG(@"unloading")];
    nameLbl.text = info.placeName;
    detailLbl.text = info.placeIntroduction;
}
@end
