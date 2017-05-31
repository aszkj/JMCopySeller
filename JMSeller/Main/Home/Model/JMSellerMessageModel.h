//
//  JMSellerMessageModel.h
//  JMSeller
//
//  Created by JM on 2017/5/22.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMBaseModel.h"

@interface JMSellerMessageModel : JMBaseModel

@property (nonatomic, copy)NSString *messageId;

@property (nonatomic, copy)NSString *messageType;

@property (nonatomic, copy)NSString *messageTitle;

@property (nonatomic, copy)NSString *messageBody;

@property (nonatomic, copy)NSString *messageDate;

@property (nonatomic, assign)BOOL messageIsRead;

@end
