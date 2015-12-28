//
//  RCStatusManager.m
//  WeSchoolStudent
//
//  Created by Liv on 14/11/11.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import "RCStatusManager.h"
#import "RCStatusDefine.h"

@interface RCStatusManager ()
@property (nonatomic ,strong)NSDictionary *statusDictionary;
@property (nonatomic ,strong)NSArray *allowShowArray;
@end
@implementation RCStatusManager

+ (instancetype)defaultManager{
    static RCStatusManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RCStatusManager alloc]init];
        
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _statusDictionary = @{
                              @(0):@"连接成功",
                              @(-1):@"未知状态",
                              @(1):@"世界上最遥远的距离就是没网,请检查网络",
                              @(2):@"设备处于飞行模式",
                              @(3):@"设备处于 2G（GPRS、EDGE）低速网络下",
                              @(4):@"设备处于 3G 或 4G（LTE）高速网络下",
                              @(5):@"设备网络切换到 WIFI 网络",
                              
                              @(6):@"账户在其他设备登录,请点击重新登录",
                              @(7):@"用户账户在 Web 端登录",
                              @(8):@"服务器异常无法连接,请点击重新登录",
                              @(9):@"验证异常",
                              @(10):@"开始发起连接",
                              @(11):@"连接失败",
                              @(12):@"注销",
                              @(31004):@"Token无效,请点击重新登录",
                              @(31011):@"服务器断开连接"
                              };
        _allowShowArray = @[@(1),@(2),@(6),@(8),@(31004)];
        
    }
    return self;
}
- (void)setStatus:(RCConnectionStatus)status{
    _status = status;
    if ([_allowShowArray containsObject:[NSNumber numberWithInteger:_status]]) {
        if ([self.delegate respondsToSelector:@selector(statusChangedWithStatusString:)]) {
            NSString *statusString = [_statusDictionary objectForKey:[NSNumber numberWithInteger:_status]];
            [self.delegate statusChangedWithStatusString:statusString];
        }
    }else{
        [self.delegate statusChangedWithStatusString:nil];
    }
    
}
@end
