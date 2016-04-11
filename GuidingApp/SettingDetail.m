//
//  SettingDetail.m
//  GuidingApp
//
//  Created by 何定飞 on 15/9/8.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import "SettingDetail.h"
#import "GCDiscreetNotificationView.h"
#import "DFTools.h"

@implementation PSWTextField

-(CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.origin.x+20, bounds.origin.y, bounds.size.width, bounds.size.height);
}

-(CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.origin.x+20, bounds.origin.y, bounds.size.width, bounds.size.height);
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.origin.x+20, bounds.origin.y, bounds.size.width, bounds.size.height);
}

-(CGRect)clearButtonRectForBounds:(CGRect)bounds{
    return CGRectMake(300, bounds.origin.y+3, 36, 36);
}



@end

@implementation MyTextView


@end

@interface SettingDetail ()
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (strong, nonatomic) IBOutlet UITableView *tipsView;
@property (strong, nonatomic) IBOutlet UITextView *returnMsg;

//更改密码界面
@property (weak, nonatomic) IBOutlet PSWTextField *old_Psw;
@property (weak, nonatomic) IBOutlet PSWTextField *now_Psw1;
@property (weak, nonatomic) IBOutlet PSWTextField *now_Psw2;

@end

@implementation SettingDetail{
    NSMutableDictionary *preference;
    
    UISwitch *switch1 ;
    NSMutableArray *pickerData1;
    NSMutableArray *pickerData2;
    
    UIPickerView *picker1;
    UIPickerView *picker2;
    UIView *view ;
    
    NSIndexPath *index1 ;
    NSIndexPath *index2 ;
    
    GCDiscreetNotificationView *notificationView;
}
@synthesize viewTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    preference = [[NSMutableDictionary alloc]initWithCapacity:10];
    
    self.title = viewTitle;
    if ([viewTitle isEqualToString:@"更改密码"]) {
        [self.view addSubview:_passwordView];
        _old_Psw.layer.cornerRadius = 10;
        _now_Psw1.layer.cornerRadius = 10;
        _now_Psw2.layer.cornerRadius = 10;
    }else if ([viewTitle isEqualToString:@"tips设置"]){
        preference = [self readTipsData];
        CGRect frame = _tipsView.frame;
        _tipsView.frame = frame;
        [self.view addSubview:_tipsView];
    }else if ([viewTitle isEqualToString:@"意见反馈"]){
        self.automaticallyAdjustsScrollViewInsets = NO;
        CGRect rect = _returnMsg.frame;
        rect.origin.x = 15;
        rect.origin.y = 80;
        _returnMsg.frame = rect;
        _returnMsg.layer.borderWidth = 1;
        _returnMsg.layer.cornerRadius = 10;
        
        _returnMsg.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
        UIControl *control1 = [[UIControl alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        [control1 insertSubview:self.view belowSubview:_returnMsg];
        [control1 addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_returnMsg];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(commitData)];
    
    
    
    view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    view.backgroundColor = [UIColor darkGrayColor];
    view.alpha = 0;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(finishChange:)]];
    
    [self.view addSubview:view];
    view.hidden = YES;
    
    
    picker1 = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 603, 375, 200)];
    picker2 = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 603, 375, 300)];
    picker1.delegate = self;
    picker1.dataSource = self;
    picker2.delegate = self ;
    picker2.delegate = self;
    picker1.backgroundColor = [UIColor whiteColor];
    picker2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:picker1];
    [self.view addSubview:picker2];
    

    index1 = [[NSIndexPath alloc]init];
    index2 = [[NSIndexPath alloc]init];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavigationBarAlpha:1];
    pickerData1 = [NSMutableArray arrayWithObjects:@"顶部",@"底部", nil];
    pickerData2 = [[NSMutableArray alloc]init];
    for (int i = 1; i <= 60; i ++) {
        [pickerData2 addObject:[NSNumber numberWithInt:i]];
    }
    

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark preferenceSettingData
- (NSMutableDictionary *)readTipsData{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:(NSMutableDictionary *)[user objectForKey:@"tips_setting"]];
    if (dic == nil) {
        dic = [[NSMutableDictionary alloc]initWithCapacity:10];
    }
    if ([dic objectForKey:@"tips_isOn"] == nil) {
        [dic setValue:@"1" forKey:@"tips_isOn"];
    }
    if ([dic objectForKey:@"tips_where"] == nil) {
        [dic setValue:@"顶部" forKey:@"tips_where"];
    }
    if ([dic objectForKey:@"tips_time"] == nil) {
        [dic setValue:@"1 秒" forKey:@"tips_time"];
    }
    
    notificationView = [[GCDiscreetNotificationView alloc] initWithText:@"内容"
                                                           showActivity:[dic objectForKey:@"tips_isOn"]
                                                     inPresentationMode:[[dic objectForKey:@"tips_where"] isEqualToString:@"顶部"]?  GCDiscreetNotificationViewPresentationModeTop : GCDiscreetNotificationViewPresentationModeBottom
                                                                 inView:self.view];
    
    return dic;
}

- (void)saveTipsData:(NSMutableDictionary *)dictionary{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:dictionary forKey:@"tips_setting"];
}





#pragma mark Event
- (void)switchValueChange:(id)sender{
    UISwitch *mySwitch = (UISwitch *)sender;
    [self switchStatus:mySwitch];
}

//判断Switch状态
- (void)switchStatus:(UISwitch *)mySwitch{
    if (mySwitch.isOn) {
        [UIView animateWithDuration:0.2 animations:^{
            _tipsView.frame = CGRectMake(_tipsView.frame.origin.x, _tipsView.frame.origin.y, _tipsView.frame.size.width, 320);
            [notificationView show:YES];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            _tipsView.frame = CGRectMake(_tipsView.frame.origin.x, _tipsView.frame.origin.y, _tipsView.frame.size.width, 140);
            [notificationView hide:YES];
        }];
    }
}

//关闭picker
- (void)finishChange:(id)sender{
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 0;
        picker1.transform = CGAffineTransformIdentity;
        picker2.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        view.hidden = YES;
    }];
}

- (void)commitData{
    if ([self.viewTitle isEqualToString:@"tips设置"]) {
        
        [preference setValue:[NSString stringWithFormat:@"%d",switch1.isOn] forKey:@"tips_isOn"];
        [preference setValue:[_tipsView cellForRowAtIndexPath:index1].detailTextLabel.text forKey:@"tips_where"];
        [preference setValue:[_tipsView cellForRowAtIndexPath:index2].detailTextLabel.text forKey:@"tips_time"];
        [self saveTipsData:preference];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//隐藏键盘
- (void)hideKeyboard{
    [self resignFirstResponder];
}

//tips设置
#pragma mark UITableViewDelegate && UITableViewDataSourse
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return 1;
    else
        return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 60;
    }else
        return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 367, 60)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 320, 60)];
        label.text = @"选择开启tips，你可以在首页顶部或底部看到附近景点信息";
        label.font = [UIFont fontWithName:label.font.fontName size:14];
        label.numberOfLines = 2;
        [view1 addSubview:label];
        return view1;
    }else
        return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    if (indexPath.section == 0) {
        switch1 = [[UISwitch alloc]init];
        [switch1 addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switch1;
        cell.textLabel.text = @"是否开启tips提醒";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[preference objectForKey:@"tips_isOn"] isEqualToString:@"1"]) {
            [switch1 setOn:YES];
        }else
            [switch1 setOn:NO];
    }else{
        [self switchStatus:switch1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            index1 = indexPath;
            cell.textLabel.text = @"tips显示位置";
            cell.detailTextLabel.text = [preference objectForKey:@"tips_where"];
        }else{
            index2 = indexPath;
            cell.textLabel.text = @"tips显示时间";
            cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",[preference objectForKey:@"tips_time"]];
        }
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    if (indexPath.section == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            view.hidden = NO;
            view.alpha = 0.5;
            if (indexPath.row == 0) {
                picker1.transform = CGAffineTransformMakeTranslation(0, -180);
            }else{
                picker2.transform = CGAffineTransformMakeTranslation(0, -200);
            }

        }];
    }
}

//tips设置
#pragma mark UIPickerViewDelegate && UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == picker1) {
        return pickerData1.count;
    }else
        return pickerData2.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == picker1) {
        return pickerData1[row];
    }else
        return [NSString stringWithFormat:@"%@",pickerData2[row]];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == picker1) {
        [_tipsView cellForRowAtIndexPath:index1].detailTextLabel.text = pickerData1[row];
        [notificationView setPresentationMode:[pickerData1[row] isEqualToString:@"顶部"]?GCDiscreetNotificationViewPresentationModeTop:GCDiscreetNotificationViewPresentationModeBottom];
        }
    else{
        [_tipsView cellForRowAtIndexPath:index2].detailTextLabel.text = [NSString stringWithFormat:@"%@ 秒",pickerData2[row]];
            [notificationView hideAnimatedAfter:(int)pickerData2[row]];
    }

}


#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location >= 140) {
        [self resignFirstResponder];
        return  NO;
    }
    else if(![text isEqualToString:@""]){
        
    }
        return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
