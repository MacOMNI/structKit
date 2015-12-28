//
//  MessageVC.m
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/14.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import "MessageVC.h"

@interface MessageVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.delegate=self;
//    self.tableView.dataSource=self;
    //设置含有空图片的的tableView的代理，正常的tableView 只需要实现UITableViewDataSource,UITableViewDelegate 代理即可
    self.tableView.emptyDataSetSource=self;
    self.tableView.emptyDataSetDelegate=self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadEmptyDataSet];//强制设置为空
}
#pragma mark - UITableViewDataSource and delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
