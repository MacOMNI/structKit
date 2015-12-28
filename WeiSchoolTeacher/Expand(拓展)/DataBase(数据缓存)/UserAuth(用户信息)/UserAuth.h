//
//  UserAuth.h
//  Created by MacKun on 15/8/30.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
/**
 *  用户安全鉴权对象
 */
@interface UserAuth : NSObject

/**
 *  用户名
 */
@property(nonatomic, strong, readonly) NSString *userName;

/**
 *  用户密码
 */
@property(nonatomic, strong, readonly) NSString *passWord;

/**
 *  用户id
 */
@property(nonatomic, strong, readonly) NSString *userid;

/**
 *  用户信息
 */
@property(nonatomic, strong, readonly)UserModel  *userInfo;

/**
 *  sessionId
 */
@property(nonatomic, strong, readonly) NSString *sid;

/**
 *  用户是否登录
 */
@property(nonatomic, assign, readonly) BOOL isLogin;

/**
 *  配置的地址
 */
@property(nonatomic,assign,readonly)NSString *base_url;

+ (UserAuth *)shared;

/**
 *  保存用户信息
 *
 *  @param userInfo 用户信息
 */
+ (void)saveUserInfo:(NSDictionary*)userInfo;

/**
 *  保存用户名
 *
 *  @param userName 用户名
 */
+ (void)saveUserName:(NSString*)userName;

/**
 *  保存用户id
 *
 *  @param userId 用户id
 */
+ (void)saveUserId:(NSString*)userId;

/**
 *  保存密码 输入的密码
 *
 *  @param passWord 密码
 */
+ (void)savePassWord:(NSString*)passWord;

/**
 *  保存sessionId
 *
 *  @param sid sessionId
 */
+ (void)saveSid:(NSString*)sid;
/**
 *  保存配置地址
 *
 *  @param url 地址字符串
 */
+ (void)saveBaseUrl:(NSString *) url;

/**
 *  清空用户信息
 */
+ (void)clean;
@end
