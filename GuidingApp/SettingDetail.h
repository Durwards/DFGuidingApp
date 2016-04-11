//
//  SettingDetail.h
//  GuidingApp
//
//  Created by 何定飞 on 15/9/8.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSWTextField : UITextField
@end
@interface MyTextView : UITextView
@end

@interface SettingDetail : DFBaseViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate>

@property (nonatomic,assign) NSString *viewTitle;
@end
