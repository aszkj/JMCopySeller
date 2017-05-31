//
//  DLHttpRequestManager.m
//  YilidiSeller
//
//  Created by yld on 16/3/23.
//  Copyright © 2016年 Dellidc. All rights reserved.
//

#import "AFNHttpRequestOPManager.h"
#import "AFNHttpRequestOPManager+crupo.h"
#import "AFNHttpRequestOPManager+checkNetworkStatus.h"
#import "AFNHttpRequestOPManager+errorHandle.h"
#import "AFNHttpRequestOPManager+ExternParams.h"
#import "AFNHttpRequestOPManager+setCookes.h"
#import "AFNHttpRequestOPManager+log.h"
#import "GlobleNormalConst.h"

static AFNHttpRequestOPManager *_shareAFNHttpRequestOPManager = nil;
@implementation AFNHttpRequestOPManager

+ (instancetype)sharedManager{
    
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _shareAFNHttpRequestOPManager = [[self alloc] initWithBaseURL:[NSURL URLWithString:JMBASEURL]];
        _shareAFNHttpRequestOPManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        _shareAFNHttpRequestOPManager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
        _shareAFNHttpRequestOPManager.securityPolicy.validatesDomainName = NO;//是否验证域名
        _shareAFNHttpRequestOPManager.requestSerializer.HTTPShouldHandleCookies = NO;
    });
    return _shareAFNHttpRequestOPManager;
}

#pragma mark -- post method
+ (void )postWithSubUrl:(NSString *)suburl
             parameters:(NSDictionary *)parameters
                 result:(JMNetWorkResultBlock)result
{
    [[self class] setRequestHeader];
    [[self class] checkNetWorkStatus];
    NSString *requestUrlStr = [NSString stringWithFormat:@"%@%@%@",JMBASEURL,JMModuleDomain_Common,suburl];
    [[[self class] sharedManager] POST:requestUrlStr parameters:parameters
                               success:^(NSURLSessionDataTask *task,id responseObject) {
                                   
                                   NSError *responseError = nil;
                                  [[self class] handError:&responseError withResponse:responseObject ofRequestUlr:suburl];
                                   
                                   NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                                   [[self class] cacheCookieAfterRequestWithResponse:response];
                                   [[self class] logWithResponseObject:responseObject htppResponse:response responseErrorInfo:responseError requestUrl:requestUrlStr requestParam:parameters];
                                   responseObject = responseObject[@"content"];
                                   if (result) {
                                       result(responseObject,responseError);
                                   }
                                   
                               }failure:^(NSURLSessionDataTask *task,NSError *error) {
                                   [[self class] handError:&error withResponse:nil ofRequestUlr:suburl];
                                   NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                                   NSDictionary *errorUserInfo = @{NSLocalizedDescriptionKey:error.localizedDescription};
                                   error = [NSError errorWithDomain:@"请求服务器出错" code:-1 userInfo:errorUserInfo];
                                   [[self class] logWithResponseObject:nil htppResponse:response responseErrorInfo:error requestUrl:requestUrlStr requestParam:parameters];
                                   if (result) {
                                       result(nil,error);
                                   }
                               }];
}


+ (void )getInfoWithSubUrl:(NSString *)subUrl
                parameters:(NSDictionary *)parameters
                    result:(JMNetWorkResultBlock)result{
    
    [[self class] setRequestHeader];
    [[self class] checkNetWorkStatus];
    NSString *requestUrlStr = [NSString stringWithFormat:@"%@%@%@",JMBASEURL,JMModuleDomain_Common,subUrl];
    [[[self class] sharedManager] GET:requestUrlStr parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *responseError = nil;
        [[self class] handError:&responseError withResponse:responseObject ofRequestUlr:requestUrlStr];
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        [[self class] cacheCookieAfterRequestWithResponse:response];
        [[self class] logWithResponseObject:responseObject htppResponse:response responseErrorInfo:responseError requestUrl:requestUrlStr requestParam:parameters];
        responseObject = responseObject[@"content"];
        if (result) {
            result(responseObject,responseError);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[self class] handError:&error withResponse:nil ofRequestUlr:requestUrlStr];
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *errorUserInfo = @{NSLocalizedDescriptionKey:error.localizedDescription};
        error = [NSError errorWithDomain:@"请求服务器出错" code:-1 userInfo:errorUserInfo];
        [[self class] logWithResponseObject:nil htppResponse:response responseErrorInfo:error requestUrl:requestUrlStr requestParam:parameters];
        if (result) {
            result(nil,error);
        }
    }];
    
}

+ (NSDictionary *)dealEntryParam:(NSDictionary *)entryParam {
    NSDictionary *baseParam = nil;
    if (entryParam) {
        baseParam = @{@"entity":entryParam};
    }
    NSDictionary *baseExternParam = [[self class] setNormExternParamAtBaseParam:baseParam];
    NSDictionary *base64Param = [[self class] transferToBase64ParamWithTheBasicParam:baseExternParam];
    return base64Param;
}



#pragma mark 取消网络请求
+ (void)cancelRequest{
    DDLogVerbose(@"cancelRequest");
    [[[[self class] sharedManager] operationQueue] cancelAllOperations];
    
}


@end

