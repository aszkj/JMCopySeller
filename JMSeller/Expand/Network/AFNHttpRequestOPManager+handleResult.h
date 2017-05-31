//
//  AFNHttpRequestOPManager+handleResult.h
//  JMSeller
//
//  Created by JM on 2017/5/23.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "AFNHttpRequestOPManager.h"

@interface AFNHttpRequestOPManager (handleResult)

+ (void)api_handleSuccessResultWithTask:(NSURLSessionDataTask *)task
                        responseObject:(id)responseObject
                        resultCallBack:(JMNetWorkResultBlock)result
                            requestUrl:(NSString *)requestUrl
                         requestParams:(NSDictionary *)parameters;

+ (void)api_handleFailedResultWithTask:(NSURLSessionDataTask *)task
                        error:(NSError *)error
                        resultCallBack:(JMNetWorkResultBlock)result
                           requestUrl:(NSString *)requestUrl
                        requestParams:(NSDictionary *)parameters;



@end
