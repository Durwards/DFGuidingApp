//
//  HomeNavCell.h
//  GuidingApp
//
//  Created by 何定飞 on 15/12/8.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriBtnDelegate <NSObject>
- (void)spotFriInfoBtnClick:(id)sender;
- (void)spotFriNaviBtnClick:(id)sender;
@end


@interface HomeNavCell : UITableViewCell
@property (nonatomic,assign)id <FriBtnDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *placeDetail;
@property (weak, nonatomic) IBOutlet UIButton *spotBtn;

- (void)setContentWithImageText:(NSString *)imageText withTitle:(NSString *)title withDetail:(NSString *)detail;

@end
