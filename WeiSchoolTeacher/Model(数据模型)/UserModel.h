//
//  UserModel.h
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/22.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UserModel : NSObject

NS_ASSUME_NONNULL_BEGIN

/**
 *  用户编号
 */
@property(nonatomic,copy) NSString *uYHBH;// 用户编号
/**
 *  姓名
 */
@property(nonatomic,copy) NSString *uXM;//姓名
/**
 *  用户名
 */
@property(nonatomic,copy) NSString *uRYH;//用户名
/**
 *  身份证件号
 */
@property(nonatomic,copy) NSString *uSFZJH;//身份证件号
/**
 *  性别码 0-男 1-女
 */
@property(nonatomic,copy) NSString *uXBM;//性别码 0-男 1-女
/**
 *  密码（MD5加密）
 */
@property(nonatomic,copy) NSString *uYHMM;//密码（MD5加密）
/**
 *  单位编号
 */
@property(nonatomic,copy) NSString *uDWBH;//单位编号
/**
 *  联系电话
 */
@property(nonatomic,copy) NSString *uLXDH;//联系电话
/**
 *  学号（学生）
 */
@property(nonatomic,copy) NSString *uXH;//学号（学生）
/**
 *  班级编号
 */
@property(nonatomic,copy) NSString *uclassID;//班级编号
/**
 *  班级名称
 */
@property(nonatomic,copy) NSString *uclassName;//班级名称
/**
 *  融云token
 */
@property(nonatomic,copy) NSString *utoken;//融云token
/**
 *  用户头像
 */
@property(nonatomic,copy) NSString *uZP;//用户头像
/**
 *  所在班级的人员状态
 */
@property(nonatomic,copy) NSString *ustate;//所在班级的人员状态
/**
 *  群组id
 */
@property(nonatomic,copy) NSString *urongID;//群组id
/**
 *  个人简介
 */
@property(nonatomic,copy) NSString *uGRJJ;//个人简介

NS_ASSUME_NONNULL_END
@end
