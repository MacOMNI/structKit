//
//  ContactsVC.m
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/14.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import "ContactsVC.h"
#import "SearchContactVC.h"
@interface ContactsVC ()

@end

@implementation ContactsVC

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.title=@"联系人";

    // Do any additional setup after loading the view from its nib.
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

- (IBAction)btnAction:(id)sender {
    SearchContactVC *searchVC=[[SearchContactVC alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
@end
