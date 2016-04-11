//
//  SpotView.h
//  GuidingApp
//
//  Created by 何定飞 on 15/12/8.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpotView : UIView <UITableViewDataSource,UITableViewDelegate>
- (void)setContentInfoWithId:(int)placeId;
@end
