//
//  UserAuth.m
//

#import <CommonCrypto/CommonCryptor.h>
#import "UserAuth.h"
#import "SSKeychain.h"

/**
 *  APP_名称
 */
static NSString * APP_NAME = @"appName_EnjoyLearning";
/**
 *  用户名
 */
static NSString * kUserName = @"app_kUserName";

/**
 *  用户密码
 */
static NSString * kPassword = @"app_kPassword";

/**
 *  用户id
 */
static NSString * kUserId = @"app_kUserId";

/**
 *  用户信息
 */
static NSString * kUserInfo = @"app_kUserInfo";

/**
 *  sessionId
 */
static NSString * kSessionId = @"app_kSessionId";

/**
 *  配置地址
 */
static NSString * kUrlStr = @"app_baseUrl";

/**
 *  securityAuthKey
 */
static NSString *securityAuthKey = @"!@#JNzy123_";

@interface NSString(AES256)

-(NSString *)encryptAES256:(NSString *)key;
-(NSString *)decryptAES256:(NSString *)key;

@end

@interface NSData(AES256)

-(NSData *)encryptAES256:(NSString *)key;
-(NSData *)decryptAES256:(NSString *)key;

@end

@interface UserAuth ()

@end

@implementation UserAuth

+ (UserAuth *) shared{
    static UserAuth *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[UserAuth alloc]init];
    });
    return obj;
}
- (BOOL)isLogin{
    if (self.userName || self.userInfo){
        return YES;
    }
    return NO;
}

- (UserModel*)userInfo{
    NSString *userInfoStr = [[SSKeychain passwordForService:kUserInfo account:APP_NAME] decryptAES256:securityAuthKey];
    NSDictionary *userInfoDic = [UserAuth dictionaryWithJsonString:userInfoStr];
    return [UserModel objectWithKeyValues:userInfoDic];
}

- (NSString*)userName{
    NSString *userNameStr = [[SSKeychain passwordForService:kUserName account:APP_NAME] decryptAES256:securityAuthKey];
    return userNameStr;
}

- (NSString*)passWord{
    NSString *pwdStr = [[SSKeychain passwordForService:kPassword account:APP_NAME] decryptAES256:securityAuthKey];
    return pwdStr;
}

- (NSString*)userid{
    NSString *useridStr = [[SSKeychain passwordForService:kUserId account:APP_NAME] decryptAES256:securityAuthKey];
    if(!useridStr)
    {
        useridStr=@"";
    }
    return useridStr;
}

- (NSString*)sid{
    NSString *sidStr = [[SSKeychain passwordForService:kSessionId account:APP_NAME] decryptAES256:securityAuthKey];
    return sidStr;
}
-(NSString *)base_url
{
    NSString *url = [[SSKeychain passwordForService:kUrlStr account:APP_NAME] decryptAES256:securityAuthKey];
    return url;
}

+ (void)saveUserInfo:(NSDictionary*)dictionary{
    NSString *userInfoString = [[UserAuth jsonStringWithObject:dictionary] encryptAES256:securityAuthKey];
    [SSKeychain setPassword:userInfoString forService:kUserInfo account:APP_NAME];
}

+ (void)saveUserName:(NSString*)userName{
    
    [SSKeychain setPassword:[userName encryptAES256:securityAuthKey] forService:kUserName account:APP_NAME];
}

+ (void)saveUserId:(NSString*)userId{
    [SSKeychain setPassword:[userId encryptAES256:securityAuthKey] forService:kUserId account:APP_NAME];
}

+ (void)savePassWord:(NSString*)passWord{
    [SSKeychain setPassword:[passWord encryptAES256:securityAuthKey] forService:kPassword account:APP_NAME];
}

+ (void)saveSid:(NSString*)sid{
    [SSKeychain setPassword:[sid encryptAES256:securityAuthKey] forService:kSessionId account:APP_NAME];
}
+ (void)saveBaseUrl:(NSString *)url{
    [SSKeychain setPassword:[url encryptAES256:securityAuthKey] forService:kUrlStr account:APP_NAME];
}

+ (void)clean{
    [SSKeychain deletePasswordForService:kUserInfo account:APP_NAME];
    [SSKeychain deletePasswordForService:kUserName account:APP_NAME];
    [SSKeychain deletePasswordForService:kUserId account:APP_NAME];
    [SSKeychain deletePasswordForService:kPassword account:APP_NAME];
    [SSKeychain deletePasswordForService:kSessionId account:APP_NAME];
    [SSKeychain deletePasswordForService:kUrlStr account:APP_NAME];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        return nil;
    }
    return dic;
}

+ (NSString*)jsonStringWithObject:(id)object{
    if (object == nil) {
        return nil;
    }
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end

@implementation NSString(AES256)
/**
 *  对数据进行加密
 *
 *  @param key 加密对象
 *
 *  @return 加密后数据
 */
-(NSString *)encryptAES256:(NSString *)key{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //对数据进行加密
    NSData *result = [data encryptAES256:key];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
}
/**
 *  对数据进行解密
 *
 *  @param key 需要解密的数据
 *
 *  @return 解密后的数据
 */
-(NSString *)decryptAES256:(NSString *)key{
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [data decryptAES256:key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}
@end

@implementation NSData(AES256)

- (NSData *)encryptAES256:(NSString *)key{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


- (NSData *)decryptAES256:(NSString *)key{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        
    }
    free(buffer);
    return nil;
}
@end