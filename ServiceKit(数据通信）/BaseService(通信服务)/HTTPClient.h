//
//  HTTPClient.h
//  WeSchool
//
//  Created by MacKun on 15/8/26.
//  Copyright (c) 2015年 MacKun. All rights reserved.
//

#import "AFHTTPRequestOperation.h"

@interface HTTPClient : AFHTTPRequestOperationManager

+(instancetype)sharedHTTPClient;
/**
 *  重新设置通信地址
 */
-(void)ResetBaseUrl;
/**
 *  是否连接网络
 * */
-(BOOL)isReachable;
@end
