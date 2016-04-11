//
//  FriTableCell.m
//  GuidingApp
//
//  Created by 何定飞 on 15/11/26.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "FriTableCell.h"

@implementation FriTableCell {
    __weak IBOutlet UIImageView *headerImage;
    __weak IBOutlet UILabel *placeText;
}

- (void)awakeFromNib {
    // Initialization code
    headerImage.layer.cornerRadius = headerImage.frame.size.width/2;
    headerImage.layer.borderWidth = 1;
    headerImage.layer.borderColor = DF_BORDER_COLOR.CGColor;
    headerImage.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
