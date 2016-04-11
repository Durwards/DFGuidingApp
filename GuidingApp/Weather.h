//
//  Weather.h
//  GuidingApp
//
//  Created by 何定飞 on 15/11/25.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherModel.h"

@interface Weather : UIView <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

- (void)setContentWithPlace:(NSString *)place withBackgroundImage:(NSString *)imageStr;
@end
