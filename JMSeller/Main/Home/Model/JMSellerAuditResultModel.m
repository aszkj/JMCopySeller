//
//  JMSellerAuditResultModel.m
//  JMSeller
//
//  Created by JM on 2017/5/18.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMSellerAuditResultModel.h"

@implementation JMSellerAuditResultModel

- (instancetype)initWithDefaultDataDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.auditTime = [dic sui_stringForKey:@""];
        self.auditResultTitle = [dic sui_stringForKey:@""];
        self.auditResultDescripetion = [dic sui_stringForKey:@""];
    }
    return self;
}

@end
