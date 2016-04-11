//
//  Focus.m
//  GuidingApp
//
//  Created by 何定飞 on 15/8/27.
//  Copyright (c) 2015年 Hdu. All rights reserved.
//

#import "Focus.h"
#import "FocusTableViewCell.h"


@interface Focus ()
@property (weak, nonatomic) IBOutlet UITableView *focusTableView;

@end

@implementation Focus{
    NSMutableArray *focus_array ;
    UIBarButtonItem *rightBarBtn1;
    UIBarButtonItem *rightBarBtn2;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getData];
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"我的关注";
    
    rightBarBtn1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                target:self
                                                                action:@selector(startEdit)];
    rightBarBtn2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                target:self
                                                                action:@selector(startEdit)];
    self.navigationItem.rightBarButtonItem = rightBarBtn1;
    _focusTableView.editing = NO;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark getData
- (void)getData{
}

#pragma mark Action
- (void)startEdit{
    if (_focusTableView.editing) {
        [_focusTableView setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem = rightBarBtn1;
    }else{
        [_focusTableView setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem = rightBarBtn2;
    }
    
}


#pragma mark UITableViewDelegate&&UITableViewDataSourse
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return focus_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"TableViewReuseID";
    FocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FocusTableViewCell" owner:self options:nil]firstObject];
        cell.layer.cornerRadius = 5;
        cell.layer.masksToBounds = YES;
//        [cell setContentView:focus_array[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, 359, 15)];
//}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [focus_array removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat pageSize = 250 + 15;
    NSInteger page = roundf(offset.x / pageSize);
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, offset.y);
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"%f",scrollView.contentOffset.y);
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}



@end
