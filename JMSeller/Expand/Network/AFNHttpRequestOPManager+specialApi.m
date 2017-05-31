//
//  AFNHttpRequestOPManager+specialApi.m
//  JMSeller
//
//  Created by JM on 2017/5/22.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "AFNHttpRequestOPManager+specialApi.h"
#import "AFNHttpRequestOPManager+checkNetworkStatus.h"
#import "AFNHttpRequestOPManager+errorHandle.h"
#import "AFNHttpRequestOPManager+log.h"
#import "AFNHttpRequestOPManager+setCookes.h"
#import "AFNHttpRequestOPManager+handleResult.h"


@implementation AFNHttpRequestOPManager (specialApi)

+ (void)api_GetLoginImgVaryCode:(JMNetWorkResultBlock)resultBlock {
    [[self class] checkNetWorkStatus];
    NSString *requestUrlStr = [NSString stringWithFormat:@"%@%@",JMBASEURL,JMModuleDomain_Refresh];
    [[self class] setAjaxRequestHeader];
    DDLogVerbose(@"请求头HttpHeaders---%@",[[[[self class] sharedManager] requestSerializer] HTTPRequestHeaders]);
    [[[self class] sharedManager] GET:requestUrlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (resultBlock && responseObject) {
            resultBlock(responseObject,nil);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[self class] handError:&error withResponse:nil ofRequestUlr:requestUrlStr];
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *errorUserInfo = @{NSLocalizedDescriptionKey:error.localizedDescription};
        JMFormat(@"error description --- %@",error.localizedDescription);
        JMFormat(@"error localizedFailureReason --- %@",error.localizedFailureReason);
        JMFormat(@"error userInfo --- %@",error.userInfo);

        error = [NSError errorWithDomain:@"请求验证码出错" code:-1 userInfo:errorUserInfo];
        [[self class] logWithResponseObject:nil htppResponse:response responseErrorInfo:error requestUrl:requestUrlStr requestParam:nil];
        if (resultBlock) {
            resultBlock(nil,error);
        }
    }];
}

+ (void)api_varyTickWithCode:(NSString *)code
                      shopId:(NSString *)shopId
                     resutlt:(JMNetWorkResultBlock)resultBlock
{
    [[self class] setRequestHeader];
    [[self class] checkNetWorkStatus];
    NSString *requestUrlStr = [NSString stringWithFormat:@"%@%@%@%@%@",JMBASEURL,JMModuleDomain_Common,KUrl_VaryfyTicket,code,@"/use/"];
    NSDictionary *parameters = @{@"shop_id":shopId};
    [[[self class] sharedManager] POST:requestUrlStr parameters:parameters
                               success:^(NSURLSessionDataTask *task,id responseObject) {
                                   
                                   [[self class] api_handleSuccessResultWithTask:task responseObject:responseObject resultCallBack:^(NSDictionary *result, NSError *error) {
                                       resultBlock(result,error);
                                   } requestUrl:requestUrlStr requestParams:nil];
                                   
                               }failure:^(NSURLSessionDataTask *task,NSError *error) {
                                   [[self class] api_handleFailedResultWithTask:task error:error resultCallBack:^(NSDictionary *result, NSError *error) {
                                       resultBlock(result,error);
                                   } requestUrl:requestUrlStr requestParams:nil];
                               }];


}

+ (void)api_getSalesManInfoWithShopId:(NSString *)shopId
                              resutlt:(JMNetWorkResultBlock)resultBlock
{
    [[self class] setRequestHeader];
    [[self class] checkNetWorkStatus];
    NSString *requestUrlStr = [NSString stringWithFormat:@"%@%@%@",KUrl_GetBussinessInfo,shopId,@"/info/"];
    [[[self class] sharedManager] GET:requestUrlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [[self class] api_handleSuccessResultWithTask:task responseObject:responseObject resultCallBack:^(NSDictionary *result, NSError *error) {
            resultBlock(result,error);
        } requestUrl:requestUrlStr requestParams:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
     
        [[self class] api_handleFailedResultWithTask:task error:error resultCallBack:^(NSDictionary *result, NSError *error) {
            resultBlock(result,error);
        } requestUrl:requestUrlStr requestParams:nil];
    }];



}


+ (void)setAjaxRequestHeader {
    [[[[self class] sharedManager] requestSerializer] setValue:@"XMLHttpRequest"  forHTTPHeaderField:@"X-Requested-With"];
}



@end
