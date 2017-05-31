//
//  JMStoreOwnerModel.h
//  JMSeller
//
//  Created by JM on 2017/5/22.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMBaseModel.h"

@interface JMStoreOwnerModel : JMBaseModel

@property (nonatomic, copy)NSString *storeLogo;

/**
 是否是员工端超级账号登陆
 */
@property (nonatomic, assign)BOOL is_employee_superuser;

@property (nonatomic, assign)BOOL check_store_owner;

@property (nonatomic, copy)NSString *tel;

/**
 门店所有者账号名称
 */
@property (nonatomic, copy)NSString *store_owner_username;

/**
 门店列表
 */
@property (nonatomic, copy)NSArray *shops;



@end
