//
//  NSString+MAC.h
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/11.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(MAC)

/**
 *  判断字符串是否为空
 */
-(BOOL)isBlank;

/**
 *  MD5加密
 */
-(NSString *)md5String;
/**
 *  计算相应字体下指定宽度的字符串高度
 */
- (CGFloat)textHeightWithFont:(UIFont *)font width:(CGFloat)width;

@end
