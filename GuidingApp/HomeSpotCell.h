//
//  HomeSpotCell.h
//  GuidingApp
//
//  Created by 何定飞 on 15/12/10.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeSpotBtnDelegate <NSObject>
- (void)spotNavBtnClick:(id)sender;

@end

@interface HomeSpotCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *spotName;
@property (weak, nonatomic) IBOutlet UIButton *spotBtn;
@property (nonatomic,assign)id <HomeSpotBtnDelegate> delegate;

@end
