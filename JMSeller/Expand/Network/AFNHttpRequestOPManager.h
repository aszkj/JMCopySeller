//
//  DLHttpRequestManager.h
//  YilidiSeller
//
//  Created by yld on 16/3/23.
//  Copyright © 2016年 Dellidc. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPSessionManager.h>

typedef void(^JMNetWorkResultBlock)(NSDictionary* result, NSError *error);

@interface AFNHttpRequestOPManager : AFHTTPSessionManager
+ (instancetype)sharedManager;
/*
 *brief post方法获取数据
 *param Parameters 参数字典集合
 *param suburl 接口地址
 *param block  数据回调block
 */
+ (void )postWithSubUrl:(NSString *)suburl
             parameters:(NSDictionary *)parameters
                 result:(JMNetWorkResultBlock)result;


/*
 *brief get方法获取数据
 *param Parameters 参数字典集合
 *param suburl 接口地址
 *param block  数据回调block
 */
+ (void )getInfoWithSubUrl:(NSString *)subUrl
                parameters:(NSDictionary *)parameters
                    result:(JMNetWorkResultBlock)result;

/*
 *brief 取消网络请求
 */
+ (void)cancelRequest;

/**
 *  处理入参，添加额外参数，base64
 *
 *  @param entryParam 入参
 *
 *  @return 处理后的参数
 */

+ (NSDictionary *)dealEntryParam:(NSDictionary *)entryParam;

@end




