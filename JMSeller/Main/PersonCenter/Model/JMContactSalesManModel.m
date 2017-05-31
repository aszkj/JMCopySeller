//
//  JMContactSalesManModel.m
//  JMSeller
//
//  Created by JM on 2017/5/18.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMContactSalesManModel.h"

@implementation JMContactSalesManModel

- (instancetype)initWithDefaultDataDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.saleManName = [dic sui_stringForKey:@"name"];
        self.saleManPhoneNumber = [dic sui_stringForKey:@"phone"];
    }
    return self;
}


@end
