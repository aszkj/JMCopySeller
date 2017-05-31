//
//  AFNHttpRequestOPManager+specialApi.h
//  JMSeller
//
//  Created by JM on 2017/5/22.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "AFNHttpRequestOPManager.h"

@interface AFNHttpRequestOPManager (specialApi)

+ (void)api_GetLoginImgVaryCode:(JMNetWorkResultBlock)resultBlock;

+ (void)api_varyTickWithCode:(NSString *)code
                      shopId:(NSString *)shopId
                     resutlt:(JMNetWorkResultBlock)resultBlock;

+ (void)api_getSalesManInfoWithShopId:(NSString *)shopId
                              resutlt:(JMNetWorkResultBlock)resultBlock;




@end
