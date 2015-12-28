//
//  NSObjcet+MAC.m
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/14.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import "NSObjcet+MAC.h"

@implementation NSObject(MAC)

- (id)jsonValue
{
    NSString *responseMessage = [[NSString alloc]initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
    NSData* data = [responseMessage dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
    
}
- (id)jsonBase64Value{
   // NSString *responseMessage = [[NSString alloc]initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
   //; NSData* data = [responseMessage dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:&error];
    if (error != nil) return nil;
    if ([result isKindOfClass:[NSDictionary class]]) {
        result= [self decodeBase64Dictionary:result];
    }
    return result;
}

#pragma mark private methods
- (NSMutableDictionary *)decodeBase64Dictionary:(NSDictionary *)base64Dictionary{
    NSArray *keyArray = [base64Dictionary allKeys];
    NSMutableDictionary *decodeDic = [[NSMutableDictionary alloc]init];
    for (NSString *key in keyArray) {
        //NSString *base64Value = [userDic objectForKey:key];
        NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:[base64Dictionary objectForKey:key] options:0];
        NSString *decodeString = [[NSString alloc]initWithData:decodeData encoding:NSUTF8StringEncoding];
        [decodeDic setValue:decodeString forKey:key];
    }
    return decodeDic;
}

@end
