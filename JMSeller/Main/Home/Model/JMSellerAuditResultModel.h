//
//  JMSellerAuditResultModel.h
//  JMSeller
//
//  Created by JM on 2017/5/18.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMBaseModel.h"

@interface JMSellerAuditResultModel : JMBaseModel

@property (nonatomic, copy)NSString *auditTime;

@property (nonatomic, copy)NSString *auditResultTitle;

@property (nonatomic, copy)NSString *auditResultDescripetion;

@end
