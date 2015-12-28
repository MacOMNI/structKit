//
//  NSObjcet+MAC.h
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/14.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(MAC)
/**
 *  将基类转换为Json字典
 */
- (id)jsonValue;
/**
 * 将Base64Json基类转为Json字典
 */
- (id)jsonBase64Value;

@end
