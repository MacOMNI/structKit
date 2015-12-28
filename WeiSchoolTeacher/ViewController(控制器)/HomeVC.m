//
//  HomeVC.m
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/14.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import "HomeVC.h"
#import "HomeMessageCell.h"

@interface HomeVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation HomeVC

-(void)dealloc
{
    self.tableView.dataSource=nil;
    self.tableView.delegate=nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.title=@"首页";
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)initUI
{
    _tableView.delegate=self;
    _tableView.dataSource=self;
    self.tableView.tableFooterView = [UIView new];

}
#pragma mark - UITableView DataSource and delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    HomeMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = (HomeMessageCell *)[HomeMessageCell nibCell];
    }
    //[cell.imgView setImage:[UIImage imageNamed:@"default_collection_portrait"]];
    cell.labelName.text=[NSString stringWithFormat:@"张三%ld",(long)indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mar
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
