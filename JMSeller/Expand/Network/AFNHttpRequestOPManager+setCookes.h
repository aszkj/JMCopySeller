//
//  AFNHttpRequestOPManager+setCookes.h
//  YilidiBuyer
//
//  Created by yld on 16/5/24.
//  Copyright © 2016年 yld. All rights reserved.
//

#import "AFNHttpRequestOPManager.h"

@interface AFNHttpRequestOPManager (setCookes)

/**
 *  设置请求头
 */
+ (void)setRequestHeader;

/**
 设置cookie,sessionId,token
 */
+ (void)setCookie;

/**
 *  清除SessionIdcookie
 */
+ (void)clearCookie;

/**
 缓存cookie，请求之后
 */
+ (void)cacheCookieAfterRequestWithResponse:(NSHTTPURLResponse *)response;

@end
