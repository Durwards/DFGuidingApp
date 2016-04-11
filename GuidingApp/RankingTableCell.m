//
//  RankingTableCell.m
//  GuidingApp
//
//  Created by 何定飞 on 15/11/26.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "RankingTableCell.h"
#import "UIImageView+WebCache.h"

@implementation RankingTableCell
{
    __weak IBOutlet UIImageView *placeImage;
    __weak IBOutlet UILabel *placeName;
    __weak IBOutlet UILabel *placeIntroduction;
    __weak IBOutlet UILabel *placeLikes;
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setContentInfo:(PlaceBasic *)info {
    placeImage.layer.cornerRadius = 5;
    [placeImage sd_setImageWithURL:[NSURL URLWithString:info.placeImage] placeholderImage:IMG(@"unloading")];
    placeName.text = info.placeName;
    placeIntroduction.text = info.placeIntroduction;
    placeLikes.text = [NSString stringWithFormat:@"%d",info.placeLikes];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
