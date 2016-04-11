//
//  Setting.m
//  GuidingApp
//
//  Created by 何定飞 on 15/8/27.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import "Setting.h"
#import "SettingDetail.h"

@interface Setting ()
@property (strong, nonatomic) IBOutlet UIView *footer1;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation Setting

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.title = @"设置";
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_tableView reloadData];
}


#pragma mark UITableViewDelegate && UITableViewDataSourse

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"1";
    }
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = @"是否开启位置服务";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            Location *mylocation  = [Location sharedLocation];
            if ([mylocation isLocationOpen])
                cell.detailTextLabel.text = @"已开启";
            else
                cell.detailTextLabel.text = @"未开启";
        }
            break;
        case 1:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"更改密码";
            }else if(indexPath.row == 1){
                cell.textLabel.text = @"tips设置";
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"清除缓存";
            } else if(indexPath.row == 1){
                cell.textLabel.text = @"意见反馈";
            } else{
                cell.textLabel.text = @"关于软件";
            }
            break;
        default:
            break;
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
    }else if (indexPath.section == 1 ){
        
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return 1;
    else if (section == 1)
        return 2;
    else
        return 3;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        _footer1.bounds = CGRectMake(20, 0, 300, 50);
        return _footer1;
    }
    else
        return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 1;
    }else if(section == 0)
        return 65;
    else
        return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        if (indexPath.section == 2 && indexPath.row == 0) {
            [[tableView cellForRowAtIndexPath:indexPath]setSelected:NO];
        }else{
            SettingDetail *settingDetail = [[SettingDetail alloc]init];
            settingDetail.viewTitle = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
            [self.navigationController pushViewController:settingDetail animated:YES];
            [[tableView cellForRowAtIndexPath:indexPath]setSelected:NO];
        }
    }
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
