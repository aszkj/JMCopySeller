//
//  AFNHttpRequestOPManager+handleResult.m
//  JMSeller
//
//  Created by JM on 2017/5/23.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "AFNHttpRequestOPManager+handleResult.h"
#import "AFNHttpRequestOPManager+errorHandle.h"
#import "AFNHttpRequestOPManager+log.h"
#import "AFNHttpRequestOPManager+setCookes.h"

@implementation AFNHttpRequestOPManager (handleResult)

+ (void)api_handleSuccessResultWithTask:(NSURLSessionDataTask *)task
                        responseObject:(id)responseObject
                        resultCallBack:(JMNetWorkResultBlock)result
                            requestUrl:(NSString *)requestUrl
                         requestParams:(NSDictionary *)parameters
{
    NSError *responseError = nil;
    [[self class] handError:&responseError withResponse:responseObject ofRequestUlr:requestUrl];
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    [[self class] cacheCookieAfterRequestWithResponse:response];
    [[self class] logWithResponseObject:responseObject htppResponse:response responseErrorInfo:responseError requestUrl:requestUrl requestParam:parameters];
    responseObject = responseObject[@"content"];
    if (result) {
        result(responseObject,responseError);
    }
}

+ (void)api_handleFailedResultWithTask:(NSURLSessionDataTask *)task
                                error:(NSError *)error
                       resultCallBack:(JMNetWorkResultBlock)result
                           requestUrl:(NSString *)requestUrl
                        requestParams:(NSDictionary *)parameters
{

    [[self class] handError:&error withResponse:nil ofRequestUlr:requestUrl];
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSDictionary *errorUserInfo = @{NSLocalizedDescriptionKey:error.localizedDescription};
    error = [NSError errorWithDomain:@"请求服务器出错" code:-1 userInfo:errorUserInfo];
    [[self class] logWithResponseObject:nil htppResponse:response responseErrorInfo:error requestUrl:requestUrl requestParam:parameters];
    if (result) {
        result(nil,error);
    }

}



@end
