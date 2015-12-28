//
//  MainTabBarController.m
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/14.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import "MainTabBarController.h"
#import "UIColor+WeSchool.h"
#import "UIImage+Additions.h"
#import "UIColor+Mac.h"
#import "UIViewController+MLTransition.h"
#import "ContactsVC.h"
#import "HomeVC.h"
#import "MessageVC.h"
@interface MainTabBarController ()
@property (nonatomic, strong) NSArray *controllerArray;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor appTextColor]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor appBlueColor]} forState:UIControlStateHighlighted];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor appBlueColor]} forState:UIControlStateSelected];
    [self.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor appNavigationBarColor]]];
    NSArray *tabImageArray = @[@"sy_home",@"sy_fuwu",@"sy_wode_high"];
    NSArray *tabSelectedImageArray = @[@"sy_home_high",@"sy_fuwu_high",@"sy_wode_high"];
    NSArray *tabNameArray = @[@"首页",@"消息",@"联系人"];
    //动态创建ViewController
    
    for(int i=0;i<self.controllerArray.count;i++)
    {
        Class cl=NSClassFromString(_controllerArray[i]);
        BaseViewController *viewController=[[cl alloc]init];
        viewController.tabBarItem.title=tabNameArray[i];
        viewController.tabBarItem.image=[UIImage imageNamed:tabImageArray[i]];
        viewController.tabBarItem.selectedImage=[UIImage imageNamed:tabSelectedImageArray[i]];
        viewController.title=tabNameArray[i];
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:viewController];
        [self addChildViewController:nav];
    }
}
- (NSArray *)controllerArray
{
    if (_controllerArray == nil) {
        _controllerArray = @[@"HomeVC", @"MessageVC", @"ContactsVC"];
    }
    return _controllerArray;
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
