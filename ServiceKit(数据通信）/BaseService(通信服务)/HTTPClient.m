//
//  HTTPClient.m
//  WeSchool
//
//  Created by MacKun on 15/8/26.
//  Copyright (c) 2015年 MacKun. All rights reserved.
//

#import "HTTPClient.h"
#import "AFSecurityPolicy.h"
#import "Reachability.h"
static HTTPClient *_sharedHTTPClient=nil;
static Reachability* _reach=nil;
@implementation HTTPClient

+(instancetype)sharedHTTPClient
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        //_sharedHTTPClient=[[HTTPClient alloc]initWithBaseURL:[NSURL URLWithString:[UserAuth shared].base_url]];
        _sharedHTTPClient=[[HTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"https://10.8.1.48"]];
        _reach = [Reachability reachabilityWithHostname:@"https://10.8.1.48"];
        [_reach startNotifier];
    });
    
    return _sharedHTTPClient;
}

-(void)ResetBaseUrl
{
    _sharedHTTPClient=[[HTTPClient alloc]initWithBaseURL:[NSURL URLWithString:[UserAuth shared].base_url]];
    _reach = [Reachability reachabilityWithHostname:[UserAuth shared].base_url];
    [_reach startNotifier];

}
-(BOOL)isReachable
{
    return _reach.isReachable;
}
-(instancetype)initWithBaseURL:(nullable NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
   
   // [self.requestSerializer setAuthorizationHeaderFieldWithUsername:@"XYZ" password:@"xyzzzz"];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
     self.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.requestSerializer.timeoutInterval = 10.0;
   //self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    
    securityPolicy.validatesDomainName = NO;
    self.securityPolicy = securityPolicy;
    return self;
}
-(void)netWorkStatus
{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
      [reach startNotifier];
}

@end
