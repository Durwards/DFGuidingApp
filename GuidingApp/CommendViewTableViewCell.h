//
//  CommendViewTableViewCell.h
//  GuidingApp
//
//  Created by 何定飞 on 15/11/12.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommandCellBtnDelegate<NSObject>
@required
- (void)placeCellClick:(id)sender;

@end

@interface CommendViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (nonatomic,assign)id<CommandCellBtnDelegate> delegate;

- (void)setLeftContent:(PlaceBasic *)leftInfo withRightContent:(PlaceBasic *)rightInfo;

@end
