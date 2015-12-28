//
//  RCStatusManager.h
//  WeSchoolStudent
//
//  Created by Liv on 14/11/11.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

#define RCStatus [RCStatusManager defaultManager]

@protocol StatusChangedDelegate <NSObject>
- (void)statusChangedWithStatusString:(NSString *)statusString;
@end

@interface RCStatusManager : NSObject

+ (instancetype)defaultManager;

@property (nonatomic ,assign)RCConnectionStatus status;

@property (nonatomic ,strong)id <StatusChangedDelegate>delegate;
@end
