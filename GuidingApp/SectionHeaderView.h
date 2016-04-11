//
//  SectionHeaderView.h
//  GuidingApp
//
//  Created by 何定飞 on 15/11/12.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SectionMoreBtnDelegate<NSObject>
@required
- (void)moreBtnClick:(id)sender;

@end

@interface SectionHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *_moreBtn;
@property (weak, nonatomic) IBOutlet UIImageView *sectionImg;
@property (weak, nonatomic) IBOutlet UILabel *sectionTitle;

@property (nonatomic,assign)id<SectionMoreBtnDelegate> delegate;

@end
