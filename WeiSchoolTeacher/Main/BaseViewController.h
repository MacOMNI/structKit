//
//  BaseViewController.h
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/14.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIScrollView+EmptyDataSet.h"

@interface BaseViewController : UIViewController<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


#pragma  mark 设置左右两侧NavBarItem
/**
 *  设置左侧文字形式的BarItem
 */
- (void)setLeftBarWithString:(NSString*)string;
/**
 *  设置左侧图片形式的BarItem
 */
- (void)setLeftBarWithImage:(NSString *)imageName;
/**
 *  设置右侧文字形式的BarItem
 */
- (void)setRightBarWithString:(NSString*)string;
/**
 *  设置右侧图片形式的BarItem
 */
- (void)setRightBarWithImage:(NSString *)imageName;

#pragma mark - 导航栏左右两侧点击事件
/**
 *  已内部实现常规左侧点击返回,如有必要请重写此方法
 */
- (void)LeftBarItemAction;
/**
 *  需继承实现右侧点击事件
 */
- (void)RightBarItemAction;

#pragma  mark public mehtods



@end
