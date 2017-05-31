//
//  JMStoreOwnerModel.m
//  JMSeller
//
//  Created by JM on 2017/5/22.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMStoreOwnerModel.h"
#import "JMStoreModel.h"

@implementation JMStoreOwnerModel

- (instancetype)initWithDefaultDataDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.storeLogo = [dic sui_stringForKey:@"logo"];
        NSArray *shops = [dic sui_arrayForKey:@"shops"];
//        shops = @[@{@"id":@(2),@"name":@"呵呵"},@{@"id":@(3),@"name":@"haha"},@{@"id":@(2),@"name":@"呵呵"},@{@"id":@(3),@"name":@"haha"},@{@"id":@(2),@"name":@"呵呵"},@{@"id":@(3),@"name":@"haha"},@{@"id":@(3),@"name":@"haha"}];
        shops = [shops transferDicArrToModelArrWithModelClass:[JMStoreModel class]];
        self.shops = shops;
    }
    return self;
}


@end
