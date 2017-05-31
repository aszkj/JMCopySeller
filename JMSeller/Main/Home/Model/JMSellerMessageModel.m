//
//  JMSellerMessageModel.m
//  JMSeller
//
//  Created by JM on 2017/5/22.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMSellerMessageModel.h"

@implementation JMSellerMessageModel

- (instancetype)initWithDefaultDataDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.messageId = [dic sui_stringForKey:@"id"];
        self.messageType = [dic sui_stringForKey:@"type"];
        self.messageTitle = [dic sui_stringForKey:@"title"];
        self.messageBody = [dic sui_stringForKey:@"body"];
        self.messageDate = [dic sui_stringForKey:@"date"];
        self.messageIsRead = [dic sui_boolForKey:@"read"];
    }
    return self;
}


@end
