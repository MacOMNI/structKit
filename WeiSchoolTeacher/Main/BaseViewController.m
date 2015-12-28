//
//  BaseViewController.m
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/14.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];//导航栏以及背景色
    [self initLeftBarItem]; //左侧BarItem
  
}
#pragma mark 导航栏以及背景色
-(void)initNavBar
{
    
    self.navigationController.title=self.title;
    self.view.backgroundColor=[UIColor appBackGroundColor];
    //更改导航栏的背景和文字Color
    [self.navigationController.navigationBar setBarTintColor:[UIColor appNavigationBarColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor appTextColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18.0f],NSFontAttributeName,nil]];
   // self.navigationController.navigationBar.translucent=YES;
    //更改按钮及其文字颜色
    [[UINavigationBar appearance] setTintColor:[UIColor appNavigationBarColor]];
    
    self.view.clipsToBounds=YES;//这个属性必须打开否则返回的时候会出现黑边

    self.edgesForExtendedLayout=UIRectEdgeNone;
}
#pragma mark 设置左右两侧NavBarItem
-(void)initLeftBarItem
{
    if(self.navigationController.viewControllers.count>1)
    {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_leftBarItemImage"] style:UIBarButtonItemStyleDone target:self action:@selector(LeftBarItemAction)];
        self.navigationItem.leftBarButtonItem = leftItem;
    }else
    {
        
    }
}
- (void)setLeftBarWithString:(NSString*)string
{
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithTitle:string style:UIBarButtonItemStylePlain target:self action:@selector(LeftBarItemAction)];
    self.navigationItem.leftBarButtonItem  = leftButtonItem;

}
- (void)setLeftBarWithImage:(NSString *)imageName
{
    UIBarButtonItem *leftButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStyleDone target:self action:@selector(LeftBarItemAction)];;
    self.navigationItem.leftBarButtonItem  = leftButtonItem;
}
- (void)setRightBarWithString:(NSString*)string
{
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:string style:UIBarButtonItemStylePlain target:self action:@selector(RightBarItemAction)];
    self.navigationItem.rightBarButtonItem  = rightButtonItem;
}
- (void)setRightBarWithImage:(NSString *)imageName{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStyleDone target:self action:@selector(RightBarItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark 左右两侧NavBarItem事件相应

- (void)LeftBarItemAction
{
    if(self.navigationController.viewControllers.count>1)
    {
        [self.view endEditing:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)RightBarItemAction
{
    
}
#pragma mark public methods

#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"你访问的请求为空";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"亲，咋没有数据呢，刷新试试~~";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"placeholder_dropbox"];
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor appBackGroundColor];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -20.0f;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0.0f;
}
#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
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
