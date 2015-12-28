//
//  BaseService.h
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/11.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  HTTP访问回调
 *
 *  @param urlString 访问地址
 *  @param result    返回数据
 *  @param error     错误描述
 */
typedef void(^ResultBlock)(NSString* urlString, id result, NSError *error);

@interface BaseService : NSObject

/**
 *  普通的访问请求
 *
 *  @param URLString    接口地址
 *  @param parameters   字典参数
 *  @param requestBlock 回调函数
 */
+ (void)POST:(NSString *)URLString  parameters:(id)parameters result:(ResultBlock)requestBlock;

/**
 *  访问请求(带缓存)
 *
 *  @param URLString    请求地址
 *  @param parameters   请求参数
 *  @param requestBlock 请求回调
 */
+ (void)POSTWithCache:(NSString *)URLString parameters:(id)parameters  completionBlock:(ResultBlock)requestBlock;

//-(id)getCacheData:(NSString *)URLString;

@end
