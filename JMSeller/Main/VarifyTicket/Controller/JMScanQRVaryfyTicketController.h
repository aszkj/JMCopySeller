//
//  HCScanQRViewController.h
//  HCSystemicQRCodeDemo
//
//  Created by Caoyq on 16/5/4.
//  Copyright © 2016年 honeycao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSellerBaseController.h"

typedef void(^successBlock)(NSString *QRCodeInfo);
@interface JMScanQRVaryfyTicketController : JMSellerBaseController

@property (strong, nonatomic) successBlock block;

/**
 *将扫码成功后获得的 二维码/条形码 信息进行回传
 */
- (void)successfulGetQRCodeInfo:(successBlock)success;

@end
