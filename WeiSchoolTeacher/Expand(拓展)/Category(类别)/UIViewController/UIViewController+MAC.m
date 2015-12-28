//
//  UIViewController+MAC.m
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/16.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import "UIViewController+MAC.h"


@implementation UIViewController(MAC)


-(void)showAlertMessage:(NSString*)message
{
    MMPopupItemHandler block = ^(NSInteger index){
        NSLog(@"clickd %@ button",@(index));
    };
    NSArray *items =
    @[MMItemMake(@"确定", MMItemTypeHighlight, block)];
    
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                         detail:message
                                                          items:items];
    
    [alertView show];

//   #if __IPHONE_8_0
//    if ([UIAlertController class]) {
//        [self showAlertView:message];
//    }
//   #else
//    UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
//                                                  message:message
//                                                 delegate:nil
//                                        cancelButtonTitle:@"确定"
//                                        otherButtonTitles:nil];
//    [alert show];
//
//   #endif
  
}
-(void)showAlertView:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    // 创建按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        [alertController popoverPresentationController];
    }];
    // 添加按钮 将按钮添加到UIAlertController对象上
    [alertController addAction:okAction];
    
    // 将UIAlertController模态出来 相当于UIAlertView show 的方法
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
