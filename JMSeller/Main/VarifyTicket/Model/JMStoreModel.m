//
//  JMStoreModel.m
//  JMSeller
//
//  Created by JM on 2017/5/20.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMStoreModel.h"

@implementation JMStoreModel

- (instancetype)initWithDefaultDataDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
//        self.storeCityName = [dic sui_stringForKey:@""];
        self.storeName = [dic sui_stringForKey:@"name"];
        self.storeId = [dic sui_stringForKey:@"id"];
    }
    return self;
}


@end
