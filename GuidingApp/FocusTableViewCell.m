//
//  FocusTableViewCell.m
//  GuidingApp
//
//  Created by 何定飞 on 15/8/27.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import "FocusTableViewCell.h"


@interface FocusTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *placeView;
@property (weak, nonatomic) IBOutlet UILabel *placeNameText;
@property (weak, nonatomic) IBOutlet UILabel *placeDetailText;

@end

@implementation FocusTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _placeView.backgroundColor = [UIColor grayColor];
//    _placeView.layer.cornerRadius = 10;
//    _placeView.layer.masksToBounds = YES;
    self.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.layer.shadowOffset = CGSizeMake(4, 4);
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 0.8;
}


//- (void)setContentView:(FocusModel *)focus{
//    if (focus.imageUrl != nil) {
//
//    }else{
//    }
//    if (focus.placeName != nil)
//        _placeNameText.text = focus.placeName;
//    else
//        _placeNameText.text = @"placeName";
//    
//    if (focus.placeDetail != nil) {
//        _placeDetailText.text = focus.placeDetail;
//    }else
//        _placeDetailText.text = @"placeDetail";
//        
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
