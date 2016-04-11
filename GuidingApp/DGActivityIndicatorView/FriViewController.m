//
//  FriViewController.m
//  GuidingApp
//
//  Created by 何定飞 on 15/11/26.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "FriViewController.h"
#import "FriTableCell.h"

@interface FriViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FriViewController {
    NSMutableArray *friendsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    friendsArray = [[NSMutableArray alloc]init];
    [self requestFri];
    self.title = @"我的朋友";
    [self setRightBarItem:@"添加" WithColor:DF_Color WithAction:@selector(addFriendEvent)];
}

- (void)addFriendEvent {
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 50)];
    UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(25, 10, 225, 40)];
    field.placeholder = @"添加好友账号";
    field.borderStyle = UITextBorderStyleRoundedRect;
    [contentView addSubview:field];
    
    [self showNoticeViewCustomView:@"添加好友" withContentView:contentView withConfirmTitle:@"添加" withCancelTitle:@"取消" withNoticeMode:1 withIsWarning:NO];
}

#pragma mark - UITableViewDelegate && UITableViewDataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = @"FriReuseId";
    FriTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = LV0(@"FriTableCell");
    }
    if (friendsArray.count > 0) {
        MeInfo *meinfo = friendsArray[indexPath.row];
        cell.nickName.text = meinfo.nickName;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        /*此处处理自己的代码，如删除数据*/
        /*删除tableView中的一行*/
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)requestFri {
    for (int i =1; i < 4; i ++) {
        MeInfo *userInfo = [[MeInfo alloc]init];
        userInfo.nickName = [NSString stringWithFormat:@"好友%d",i];
        [friendsArray addObject:userInfo];
    }
    EXECUTE_BLOCK_IN_MAIN_BEGIN
    [_tableView reloadData];
    EXECUTE_BLOCK_END
}
@end
