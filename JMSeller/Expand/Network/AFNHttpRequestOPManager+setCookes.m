//
//  AFNHttpRequestOPManager+setCookes.m
//  YilidiBuyer
//
//  Created by yld on 16/5/24.
//  Copyright © 2016年 yld. All rights reserved.
//

#import "AFNHttpRequestOPManager+setCookes.h"
#import "NSObject+SUIAdditions.h"
#import "GlobleNormalConst.h"
#import "GlobleUnormalConst.h"
#import "ProjectNormalConst.h"

const void *cookiesKey = @"cookiesKey";

@implementation AFNHttpRequestOPManager (setCookes)

#pragma mark ---------------------Public Method------------------------------
+ (void)setRequestHeader {
    
     [self setCookie];
    
     [[[[self class] sharedManager] requestSerializer] setValue:JMBASEURL   forHTTPHeaderField:@"Referer"];
    if (KCSRToken) {
        [[[[self class] sharedManager] requestSerializer] setValue:KCSRToken   forHTTPHeaderField:@"X-CSRFToken"];
    }

}

+ (void)setCookie{
    
    NSMutableDictionary *cookieKeyValues = [NSMutableDictionary dictionaryWithCapacity:2];
    if (SESSIONID) {
        [cookieKeyValues setObject:SESSIONID forKey:JMSessionID];
    }
    
    if (KCSRToken) {
        [cookieKeyValues setObject:KCSRToken forKey:KCSRTokenKey];
    }

    [[self class] setCookieWithKeyValues:[cookieKeyValues copy]];
}



+ (void)cacheCookieAfterRequestWithResponse:(NSHTTPURLResponse *)response {
    const NSInteger cookieValueMinLengh = 2;
    NSString *sessionIdCookieStr = [[self class] _sessionIdCookieValueInResponse:response];
    if (sessionIdCookieStr.length > cookieValueMinLengh) {
        [kUserDefaults setObject:sessionIdCookieStr forKey:JMSessionID];
        [kUserDefaults synchronize];
    }
    
    NSString *tokenStr = [[self class] _csrTokenValueInResponse:response];
    if (tokenStr.length > cookieValueMinLengh) {
        [kUserDefaults setObject:tokenStr forKey:KCSRTokenKey];
        [kUserDefaults synchronize];
    }
}

+ (void)clearCookie {
    
    if (SESSIONID) {
        [kUserDefaults setObject:nil forKey:JMSessionID];
        [kUserDefaults synchronize];
    }
    
    if (KCSRToken) {
        [kUserDefaults setObject:nil forKey:KCSRTokenKey];
        [kUserDefaults synchronize];
    }

}


#pragma mark ---------------------Private Method------------------------------
+ (NSHTTPCookie *)_getCookieWithCookieValue:(NSString *)cookieValue cookieKey:(NSString *)cookieKey
{
#warning 谨记设置cookie域名一定要设置，，否则麻痹真几把坑，，
    NSDictionary *cookieDic = [NSDictionary dictionaryWithObjectsAndKeys:cookieKey, NSHTTPCookieName,
                               cookieValue, NSHTTPCookieValue,
                               @"/", NSHTTPCookiePath,
                               ServerDomain, NSHTTPCookieDomain,
                               nil];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDic];
    return cookie;
}

+ (void)_setCookies:(NSArray *)cookies
{
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    [[[[self class] sharedManager] requestSerializer] setValue:[dictCookies objectForKey:@"Cookie"]  forHTTPHeaderField:@"Cookie"];
}

+ (void)setCookieWithKeyValues:(NSDictionary *)cookieKeyValues
{
    NSMutableArray *cookies = [NSMutableArray arrayWithCapacity:cookieKeyValues.count];
    
    for (NSString *key in cookieKeyValues) {
        NSHTTPCookie *cookie = [self _getCookieWithCookieValue:cookieKeyValues[key] cookieKey:key];
        [cookies addObject:cookie];
    }
    
    [self _setCookies:[cookies copy]];
}

+ (NSString *)_allCookieValueInResponse:(NSHTTPURLResponse *)response {
    
    NSString *headerSetCookieStr = response.allHeaderFields[@"Set-Cookie"];

    return headerSetCookieStr;
}


+ (NSString *)_csrTokenValueInResponse:(NSHTTPURLResponse *)response {
    
    NSString *headerSetCookieStr = response.allHeaderFields[@"Set-Cookie"];
    return [[self class] _getCookieValueForKey:@"csrftoken" inCookieStr:headerSetCookieStr];
}


+ (NSString *)_sessionIdCookieValueInResponse:(NSHTTPURLResponse *)response {
    
    NSString *headerSetCookieStr = response.allHeaderFields[@"Set-Cookie"];
    
    return [[self class] _getCookieValueForKey:@"sessionid" inCookieStr:headerSetCookieStr];
}

+ (NSString *)_getCookieValueForKey:(NSString *)key inCookieStr:(NSString *)cookieStr{
    
    NSArray *cookies = [cookieStr componentsSeparatedByString:@";"];
    for (NSString *cookieValue in cookies) {
        if ([cookieValue containsString:key]) {
            return [[cookieValue componentsSeparatedByString:@"="] lastObject];
            break;
        }
    }
    return nil;
}


@end
