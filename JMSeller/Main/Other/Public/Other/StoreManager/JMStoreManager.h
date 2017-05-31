//
//  JMStoreManager.h
//  JMSeller
//
//  Created by JM on 2017/5/22.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMStoreModel.h"
#import "JMStoreOwnerModel.h"

@interface JMStoreManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong)JMStoreOwnerModel *currentLoginedStore;

@property (nonatomic, strong)JMStoreModel *currentSelectStore;

- (void)clearStoreInfo;

@end
