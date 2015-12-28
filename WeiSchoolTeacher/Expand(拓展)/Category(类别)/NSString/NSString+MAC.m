//
//  NSString+MAC.m
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/11.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import "NSString+MAC.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(MAC)

- (BOOL)isBlank{
    if (self == nil || self == NULL || [self isKindOfClass:[NSNull class]] || [self length] == 0 || [self isEqualToString: @"(null)"]) {
        return YES;
    }
    return NO;
}
- (NSString *)md5String
{
    const char *ptr = [self UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", md5Buffer[i]];
    }
    
    return [output copy];
}
- (CGFloat)textHeightWithFont:(UIFont *)font width:(CGFloat)width{
    CGSize size = CGSizeMake(width, CGFLOAT_MAX);
    
#if __IPHONE_7_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f){
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
        size =[self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    }
#else
    size = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#endif
    
    return size.height;
}
@end
