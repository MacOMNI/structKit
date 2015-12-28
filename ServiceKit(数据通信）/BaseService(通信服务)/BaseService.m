//
//  BaseService.m
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/11.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import "BaseService.h"
#import "Reachability.h"
#import "HttpClient.h"
#import "EGOCache.h"
#import "ALAlertBanner.h"
#define REQUEST_ERROR(aCode)    (aCode==-1009?@"亲，咋没连接网络呢~~~":@"亲，服务器在偷懒哦~~~")
#define DATA_ERROR     @"亲，服务器正在打瞌睡哦，稍后重试吧"

/**
 *  接口回调
 *
 *  @param result    返回数据
 *  @param errorCode 错误码
 *  @param messgae   错误代码
 */
typedef void(^ServerBlock)(id result, NSInteger errorCode, NSString *message);

static NSString *urlAttr=@"LeXue/App";

@implementation BaseService

+(void)POST:(NSString *)URLString  parameters:(id)parameters result:(ResultBlock)requestBlock{
   // if ([HTTPClient sharedHTTPClient].isReachable) {//有网络
        
        NSString *string = [[NSString alloc]initWithFormat:@"%@%@.aspx",urlAttr,URLString];
        [[HTTPClient sharedHTTPClient] POST:string parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (requestBlock) {
                requestBlock(string,responseObject,nil);
            }
        }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showMessage:[error code]];
            if (requestBlock) {
                requestBlock(string,nil,error);
            }
        }];
        
//    }
//    else
//    {
//        [self showMessage];
//    }
}

+(void)POSTWithCache:(NSString *)URLString parameters:(id)parameters  completionBlock:(ResultBlock)requestBlock
{
   // if ([HTTPClient sharedHTTPClient].isReachable) {//有网络
        
        NSString *string = [[NSString alloc]initWithFormat:@"%@%@.aspx",urlAttr,URLString];
        NSString *urlStr = [self urlStringWithOriginUrlString:string appendParameters:parameters];
        
        [[HTTPClient sharedHTTPClient] POST:string parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (responseObject) {
                [[EGOCache globalCache] setObject:responseObject forKey:urlStr];
            }
            else
            {
                responseObject=[[EGOCache globalCache] objectForKey:urlStr];
            }
            if (requestBlock) {
                requestBlock(string,responseObject,nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            id responseObject=[[EGOCache globalCache] objectForKey:urlStr];
            [self showMessage:[error code]];
            if (requestBlock) {
                requestBlock(string,responseObject,error);
            }
        }];
//    }
//    else
//    {
//        [self showMessage];
//    }
}

+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters{
    NSString *filteredUrl = originUrlString;
    NSString *paraUrlString = [self urlParametersStringFromParameters:parameters];
    if (paraUrlString && paraUrlString.length > 0) {
        if ([originUrlString rangeOfString:@"?"].location != NSNotFound) {
            filteredUrl = [filteredUrl stringByAppendingString:paraUrlString];
        } else {
            filteredUrl = [filteredUrl stringByAppendingFormat:@"?%@", [paraUrlString substringFromIndex:1]];
        }
        return filteredUrl;
    } else {
        return originUrlString;
    }
}

+ (NSString *)urlParametersStringFromParameters:(NSDictionary *)parameters {
    NSMutableString *urlParametersString = [[NSMutableString alloc] initWithString:@""];
    if (parameters && parameters.count > 0) {
        for (NSString *key in parameters) {
           // NSString *Key =[self urlEncode:key];
            NSString *value = parameters[key];
            value = [NSString stringWithFormat:@"%@",value];
           // value = [self urlEncode:value];
            [urlParametersString appendFormat:@",%@=%@", key, value];
        }
    }
    return urlParametersString;
}
/**
 *  展示网络状态信息
 */
+(void)showMessage:(NSInteger)code
{
    NSString *subTitle=@"尝试连接网络,并重试";
    if (code !=-1009) {
        subTitle=@"您的服务器被程序猿搬走了,稍后重试吧";
    }
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:[UIApplication sharedApplication].getCurrentViewConttoller.view
                                                        style:ALAlertBannerStyleWarning
                                                     position:ALAlertBannerPositionTop
                                                        title:REQUEST_ERROR(code)
                                                     subtitle:subTitle];
    
    /*
     optionally customize banner properties here...
     */
    
    [banner show];



}


//+ (NSString *)urlEncode:(NSString *)str {
//   NSString* encodedString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)str, CFSTR("."), CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
//    return encodedString;
//}


@end
