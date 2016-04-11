//
//  RankingViewController.h
//  GuidingApp
//
//  Created by 何定飞 on 15/11/12.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankingViewController : DFBaseViewController <UITableViewDataSource,UITableViewDelegate>

- (void)setSelectedIndex:(NSInteger)index;

@end
